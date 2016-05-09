using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
// PM> Install-package Microsoft.Hadoop.MapReduce
using Microsoft.Hadoop.MapReduce;
using System.IO;

namespace BigDataMapper
{
    class map
    {
        static void Main(string[] args)
        {

            #region Arguments
            if (args.Length > 0)
            {
                Console.SetIn(new StreamReader(args[0]));
            }
            #endregion

            #region Class member variable
            string line;
            string[] words;
            #endregion


            //Read the file line by line and create key
            while ((line = Console.ReadLine()) != null)
            {
                words = line.Split(',');
                //Transform the stream
                string key = "";
                int yearGroup;
                yearGroup = Convert.ToInt16(words[7]);
                switch (yearGroup)
                {
                    case 1 | 2:
                        key = "Child";
                        break;
                    case 3 | 4:
                        key = "Teenager";
                        break;
                    case 5 | 6 | 7 | 8:
                        key = "Junior";
                        break;
                    case 9 | 10 | 11:
                        key = "Senior";
                        break;
                    case 12 | 13 | 14 | 15 | 16 | 17 | 18:
                        key = "Grand-Senior";
                        break;

                    default:
                        key = "Other";
                        break;
                }
                //Define key value pair
                // words[3] --> State name
                // words[4] --> County/ City name
                // key --> Age Group
                // words[9] --> Population
                Console.WriteLine("{0},{1},{2}\t{3}", words[3], words[4], key, words[9]);
            }
        }
    }
}