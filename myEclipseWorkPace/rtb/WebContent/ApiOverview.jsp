  <jsp:include page="../../ApiHeader.jsp" />
      <div id="index_container" class='container' style="margin-top: 100px;">
         <div class='content'>
            <nav>
               <ul class='breadcrumb'>
                  <li class='active'>API Overview</li>
               </ul>
            </nav>
            <table class='table table-bordered'> 
               <tr>
                  <th colspan='2'>RTB Reports</th>
               </tr>
               <tr>
                  <td><a href="apiDetail?api=dailyExchangeCostAnalysis">Daily Exchange Cost Analysis</a></td>
                  <td>overview-internal</td>
               </tr> 	
               <tr>
                  <td><a href="apiDetail?api=dailyExchangeCostAnalysisByHour">Daily Exchange Cost Analysis Hour</a></td>
                  <td>overview-internal</td>
               </tr> 
               
               <tr>
                  <td><a href="apiDetail?api=dailyWinRate">Daily Win Rate</a></td>
                  <td>overview-internal</td>
               </tr>  
               <tr>
                  <td><a href="apiDetail?api=dailyWinRateExchangeBidprice">Daily Win Rate Exchange BidPrice</a></td>
                  <td>overview-internal</td>
               </tr>  
               <tr>
                  <td><a href="apiDetail?api=dailyWinRateByHour">Daily Win Rate By Hour</a></td>
                  <td>overview-internal</td>
               </tr>               
            </table>
            <nav>
               <ul class='breadcrumb'>
                  <li class='active'>Dimension Lookup</li>
               </ul>
            </nav>
            <table class='table table-bordered'> 		   
            </table>
         </div>
         
      </div>
      <jsp:include page="/footer.jsp" />
      <script src="../../scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
   </body>
</html>


