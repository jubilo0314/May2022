// See https://aka.ms/new-console-template for more information
using ConsoleApp2;

try
{
    Console.WriteLine("Enter first number: ");
    int num1 = Convert.ToInt32(Console.ReadLine());
    if(num1 < 0)
    {
        throw new NumberException();
    }
    Console.WriteLine("Enter second number: ");
    int num2 = Convert.ToInt32(Console.ReadLine());
    if( num2 < 0)
    {
        throw new NumberException();
    }
    Console.WriteLine("Enter operation");
    string operation = Console.ReadLine();

    ExceptionHandlingDemo demo = new ExceptionHandlingDemo();
    Console.WriteLine(demo.Calculate(num1, num2, operation));
}
catch (DivideByZeroException ex)
{
    Console.WriteLine(ex.Message);
}
catch (ArgumentOutOfRangeException ex)
{
    Console.WriteLine(ex.Message);
}
catch(FormatException ex)
{
    Console.WriteLine(ex.Message);
}
catch (NumberException ex)
{
    Console.WriteLine(ex.Message);
}
catch (Exception ex)
{
    Console.WriteLine(ex.Message);
}
finally
{
    Console.WriteLine("Hello finally block");
}

//Customer c = new Customer();
//c.Name = "Smith";
//Console.WriteLine(c.Name);

///c.Id = 4;
///

//Customer firstCustomer = new Customer(1, "Smith", "123@abc.com");
//Console.WriteLine($"The id for first customer is {firstCustomer.Id}");

//Customer secondCustomer = new Customer(2, "Laura", "456@abc.com", "1234567890");
//Console.WriteLine($"The phone number for second customer is {secondCustomer.Phone}");

//FullTimeEmployee fte = new FullTimeEmployee();
//fte.VirtualMethodDemo();

//PartTimeEmployee pte = new PartTimeEmployee();
//pte.VirtualMethodDemo();

//Addition demo = new Addition();
//Console.WriteLine(demo.AddNumbers(10,20,30));

//Console.WriteLine(Addition.AddNumbers(10,20,30));

//int a = 3;
//Console.WriteLine(a.EvenOrOdd());
