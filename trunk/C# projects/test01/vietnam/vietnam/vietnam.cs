using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace vietnam
{
    public class vietnam : human.human
    {
        public override string hello()
        {
            return "Xin chào";
        }
        public override string goodbye()
        {
            return "Tạm biệt";
        }
    }
}
