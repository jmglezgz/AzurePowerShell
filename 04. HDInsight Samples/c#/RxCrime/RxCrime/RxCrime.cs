using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reactive.Linq;
using System.Collections.ObjectModel;
using System.Collections.Specialized;

namespace RxCrime
{
    class RxCrime
    {
        //Create crime class data type
        class crime
        {
            public string State { get; set; }
            public string City { get; set; }
            public int Population { get; set; }
            public int TotalCriminalActivity { get; set; }
            public decimal CrimePercentage { get; set; }
        }

        static void Main(string[] args)
        {
            var crimes = new ObservableCollection<crime>();

            var CrimesChanges = Observable.FromEventPattern(
                (EventHandler < NotifyCollectionChangedEventArgs > ev)
                => new NotifyCollectionChangedEventHandler(ev),
                ev => crimes.CollectionChanged +=ev,
                ev => crimes.CollectionChanged -= ev);

            //Performing the condition to watch most area - here, the cities with crime greater than 20% will be watched/ tracked.

            var watchForMostCrimes =
                from c in CrimesChanges
                where c.EventArgs.Action == 
            NotifyCollectionChangedAction.Add
                from crm in c.EventArgs.NewItems.Cast<crime>().ToObservable()
                where crm.CrimePercentage >= 80
                select crm;

            string inputPath = @"C:\IT\in\CityCrimeDataMod.csv"; //Local path for input text file of crime data
            string outputPath = @"C:\IT\out\RxCrimeResult.txt";

            Console.WriteLine("Getting information for top Crime Areas:");
            Console.WriteLine("State -> City -> Population -> TotalCriminalActivity -> CrimePercentage");

            //Handler for the applied condition
            watchForMostCrimes.Subscribe(crm =>
            {
                Console.WriteLine("Crime data : - {0} -> {1} -> {2} -> {3} -> {4}", crm.State, crm.City, crm.Population, crm.TotalCriminalActivity, crm.CrimePercentage);

                System.IO.File.AppendAllText(outputPath, string.Format("Crime data :{0},{1},{2},{3},{4}\r\n", crm.State, crm.City, crm.Population, crm.TotalCriminalActivity, crm.CrimePercentage));
            });

            //Checking for input path correctness
            if (System.IO.File.Exists(inputPath))
            {
                //Reading the record line by line
                string[] AllCrimes = System.IO.File.ReadAllLines(inputPath);
                foreach (string crmData in AllCrimes)
                {
                    string[] crmPart = crmData.Split(',');
                    try
                    {
                        //Creating Crime Object
                        crime crimeObject = new crime()
                        {
                            State = crmPart[0],
                            City = crmPart[1],
                            Population = Convert.ToInt32(crmPart[2]),
                            TotalCriminalActivity = Convert.ToInt32(crmPart[3]),
                            CrimePercentage = Convert.ToInt32(crmPart[4])
                        };
                        //Adding Crime object
                        crimes.Add(crimeObject);

                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Error:" + ex.Message);
                            
                        break;
                    }
                }

            }
            else
            {
                Console.WriteLine("Input file for CrimeData not Found");
            }
            Console.WriteLine("Output file created at " + outputPath);
            Console.ReadKey();
        }
    }
}
