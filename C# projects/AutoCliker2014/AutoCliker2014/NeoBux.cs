﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CefSharp;
using CefSharp.WinForms;
using System.ComponentModel;
namespace AutoCliker2014
{
    class NeoBux:BuxScript
    {
        private Stack<String> urls = new Stack<string>();
        private Timer checkingTimer = new Timer();

        private string sessionCode = "A008A80ADE9DA1727A568D75423E856D9885C58C65F4CCD0";
        public override void start()
        {
            isRuning = true;
            userName = ConfigureControl.configureInfo.neoBuxUserName;
            password = ConfigureControl.configureInfo.neoBuxPassword;

            checkingTimer.Tick += new EventHandler(checkToRunNextAds);
            checkingTimer.Interval = 10000;

            webView.Load("https://www.neobux.com/m/l/");
            webView.PropertyChanged += new PropertyChangedEventHandler(this.checkWhenLoginPageLoadCompleted);
            
        }
        private void checkWhenLoginPageLoadCompleted(object sender, PropertyChangedEventArgs e)
        {
            // Console.WriteLine(e.PropertyName);
            //Console.WriteLine("IsLoading: " + webView.IsLoading);
            if (e.PropertyName.Equals("IsLoading"))
            {

                if (webView.IsLoading == false)
                {
                    Console.WriteLine("Loading page is ready to fill infomation");
                    webView.PropertyChanged -= new PropertyChangedEventHandler(this.checkWhenLoginPageLoadCompleted);
                    //Enter
                    //webView.ExecuteScript("alert('Hello Chinh');");

                    //check capcha hidden or show
                    try
                    {
                        string k3display = (string)webView.EvaluateScript("document.getElementById('Kf3').type");
                        if (k3display.Trim().Equals("text"))
                        {
                            MessageBox.Show("Please enter the captchar then click on send button, autoscript will run after that.", "Neobux Captcha");
                        }
                    }
                    catch
                    {

                    }
                    //check if user logined before
                    Object userLogin = null;
                    try
                    {
                        userLogin = webView.EvaluateScript("document.getElementById('t_conta').innerHTML");
                    }
                    catch
                    {

                    }
                    if (userLogin == null)
                    {
                        webView.ExecuteScript("document.getElementsByTagName('input')[1].value='" + this.userName + "'");
                        webView.ExecuteScript("document.getElementsByTagName('input')[2].value='" + this.password + "'");
                        webView.ExecuteScript("document.getElementById('botao_login').click()");
                        webView.PropertyChanged += new PropertyChangedEventHandler(this.checkLoginSuccessful);
                    }
                    else
                    {
                        Console.WriteLine("User has been logined!");
                        webView.ExecuteScript("document.getElementsByClassName('green')[1].click()");
                        webView.PropertyChanged += new PropertyChangedEventHandler(this.openAdsPageCompleted);
                    }



                }
            }
        }
        private void checkLoginSuccessful(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName.Equals("IsLoading"))
            {

                if (webView.IsLoading == false)
                {
                    Console.WriteLine("Login submit completed. Check login status");
                    String url = webView.Address;
                    Object userLogin = null;
                    try
                    {
                        userLogin = webView.EvaluateScript("document.getElementById('t_conta').innerHTML");
                    }
                    catch
                    {

                    }

                    if (userLogin == null)
                    {
                        Console.WriteLine("Login Failed!");
                        MessageBox.Show("Login failed! Please check your username and password");
                    }
                    else
                        if (userLogin.ToString().Equals(this.userName))
                        {
                            Console.WriteLine("Login Successful!");
                            webView.ExecuteScript("document.getElementsByClassName('green')[1].click()");
                            webView.PropertyChanged += new PropertyChangedEventHandler(this.openAdsPageCompleted);

                        }
                    
                    
                    webView.PropertyChanged -= new PropertyChangedEventHandler(this.checkLoginSuccessful);
                }
            }
        }
        private void openAdsPageCompleted(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName.Equals("IsLoading"))
            {
                if (webView.IsLoading == false)
                {
                    Console.WriteLine("Load ads page completed!");
                    //
                    //Get sessionCode
                    //
                    string baseURI = (string)webView.EvaluateScript("document.getElementsByClassName('button')[1].href");
                    Console.WriteLine(baseURI);
                    if (baseURI.IndexOf("&vl") > 0)
                    {
                        sessionCode = baseURI.Split('=')[1];
                    }
                    Console.WriteLine(sessionCode);
                    //
                    //
                    //
                    webView.PropertyChanged -= new PropertyChangedEventHandler(this.openAdsPageCompleted);
                    int countTagA = 0;
                    try
                    {
                        countTagA = (int)webView.EvaluateScript("document.getElementsByTagName('a').length");
                        Console.WriteLine(countTagA);
                        for (int i = 0; i < countTagA; i++)
                        {
                            String url = (string)webView.EvaluateScript("document.getElementsByTagName('a')[" + i + "].href");
                            String url_id = (string)webView.EvaluateScript("document.getElementsByTagName('a')[" + i + "].id");

                            if (url.IndexOf("http://www.neobux.com/v/?a=l&l=") == 0)
                            {
                                String urlImage = (string)webView.EvaluateScript("document.getElementById('" + url_id.Replace("l", "img_") + "').src");
                                //Console.WriteLine(urlImage);
                                if (!urlImage.Equals("http://cache1.neodevlda.netdna-cdn.com/imagens/estrela_16_c.gif"))
                                {
                                    //Console.WriteLine(url);
                                    urls.Push(url+"&vl="+sessionCode);
                                }
                            }
                        }
                        Console.WriteLine("Total ads links: " + urls.Count);
                        //begin read ads
                        webView.ExecuteScript("document.getElementsByClassName('green')[1].click()");
                        webView.PropertyChanged += new PropertyChangedEventHandler(this.readAds);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);

                    }

                }
            }

        }
        private void readAds(object sender, PropertyChangedEventArgs e)
        {

            if (e.PropertyName.Equals("IsLoading") && webView.IsLoading == false)
            {
                webView.PropertyChanged -= new PropertyChangedEventHandler(this.readAds);
                if (urls.Count > 0)
                {
                    string url = urls.Pop();
                    Console.WriteLine("Load ads url: " + url);
                    webView.Load(url);
                    webView.PropertyChanged += new PropertyChangedEventHandler(this.checkAdsReadingCompleted);
                }
                else
                {
                    webView.EvaluateScript("document.getElementById(\"t_conta\").click()");//logout
                    MessageBox.Show("All neobux ads are validated! You can stop the process.", "Neobux Completed!");
                    //webBrowserForm.Show();
                    stop();
                    
                }

            }
        }
        private void checkAdsReadingCompleted(object sender, PropertyChangedEventArgs e)
        {
            //Console.WriteLine("Property change: "+e.PropertyName+" | Loading status: "+webView.IsLoading);
            if (e.PropertyName.Equals("IsLoading") && webView.IsLoading == false)
            {
                webView.PropertyChanged -= new PropertyChangedEventHandler(this.checkAdsReadingCompleted);
                
                checkingTimer.Enabled = true;
                checkingTimer.Start();
                webView.PropertyChanged += new PropertyChangedEventHandler(this.readAds);
            }
        }
        private void checkToRunNextAds(object sender, EventArgs e)
        {
            try
            {
                string adsValidated = (string)webView.EvaluateScript("document.getElementById('o1').style.display");
                string checkFLashError = (string)webView.EvaluateScript("document.getElementById('om1').style.display");
                string contentBlocked = (string)webView.EvaluateScript("document.getElementById('om2').style.display");
                string error = (string)webView.EvaluateScript("document.getElementById('o0').style.display");
                string expired = (string)webView.EvaluateScript("document.getElementById('o0_err').style.display");
                if (adsValidated.Trim().Equals(""))
                {
                    Console.WriteLine("Ads validated!");
                    checkingTimer.Enabled = false;
                    checkingTimer.Stop();
                    Console.WriteLine("Remaining ads: " + urls.Count);
                    webView.Back();

                }
                else if (checkFLashError.Equals(""))
                {
                    checkingTimer.Enabled = false;
                    checkingTimer.Stop();
                    MessageBox.Show("Please install new flash plugin use this url: http://get.adobe.com/flashplayer/?fpchrome . Stop and try again!", "Flash detection failed");
                }
                else if (contentBlocked.Trim().Equals("") || error.Trim().Equals("") || expired.Trim().Equals(""))
                {
                    checkingTimer.Enabled = false;
                    checkingTimer.Stop();
                    webView.Back();
                }

            }
            catch
            {
                webView.Back();
            }
            //check special error
            try
            {
                string errorString = (string)webView.EvaluateScript("document.getElementsByClassName('f_b')[4].innerHTML");
                if (errorString.Trim().Equals("The chosen advertisement is not available."))
                {
                    webView.Back();
                }
            }
            catch
            {
                webView.Back();
            }

        }
        public override void stop()
        {
            isRuning = false;
        }

        public override bool isActive()
        {
            return ConfigureControl.configureInfo.neoBuxActive;
        }
    }
}