using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public class NumberException : Exception
    {
        public override string Message
        {
            get { return "Number cannot be negative"; }
        }
    }
}
