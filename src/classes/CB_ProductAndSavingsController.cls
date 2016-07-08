/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CB_ProductsAndSavings component. Class provides info about customer's bank accounts, credit cards, mortgages and investments
*/
global with sharing class CB_ProductAndSavingsController {

    global CB_ProductAndSavingsController() {
        
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: This method gets list of the customer's bank accounts
    * @param Id id of the customer
    * @return: List< BankAccount >
    */
    @RemoteAction
    global static List< BankAccount > getBankAccounts ( Id customerId ) {
        List< BankAccount > bankAccounts = new List< BankAccount >();
        bankAccounts.add( new BankAccount(
            '12-34-56 789101112',
            7000,
            0,
            '£'
        ) );
        bankAccounts.add( new BankAccount(
            '12-34-56 891011123',
            3000,
            0,
            '£'
        ) );
        bankAccounts.add( new BankAccount(
            '12-34-56 891011123',
            3000,
            0,
            '£'
        ) );
        bankAccounts.add( new BankAccount(
            '12-34-56 891011123',
            3000,
            0,
            '£'
        ) );
        bankAccounts.add( new BankAccount(
            '12-34-56 891011123',
            3000,
            0,
            '£'
        ) );
        bankAccounts.add( new BankAccount(
            '12-34-56 891011123',
            3000,
            0,
            '£'
        ) );
        return bankAccounts;
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: This method gets list of the customer's credit cards
    * @param Id id of the customer
    * @return: List< CreaditCard >
    */
    @RemoteAction
    global static List< CreaditCard > getCreaditCards ( Id customerId ) {
        List< CreaditCard > creaditCards = new List< CreaditCard >();
        creaditCards.add( new CreaditCard(
            '1234 5678 9101 1121',
            2000,
            1200,
            '£'
        ) );
        creaditCards.add( new CreaditCard(
            '1234 5678 9101 1121',
            2000,
            1200,
            '£'
        ) );
        creaditCards.add( new CreaditCard(
            '1234 5678 9101 1121',
            2000,
            1200,
            '£'
        ) );
        creaditCards.add( new CreaditCard(
            '1234 5678 9101 1121',
            2000,
            1200,
            '£'
        ) );
        creaditCards.add( new CreaditCard(
            '1234 5678 9101 1121',
            2000,
            1200,
            '£'
        ) );
        creaditCards.add( new CreaditCard(
            '1234 5678 9101 1121',
            2000,
            1200,
            '£'
        ) );
        return creaditCards;
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: This method gets list of the customer's mortgages
    * @param Id id of the customer
    * @return: List< Mortgage >
    */
    @RemoteAction
    global static List< Mortgage > getMortgages ( Id customerId ) {
        List< Mortgage > mortgages = new List< Mortgage >();
        mortgages.add( new Mortgage(
            '0012314235254',
            Date.today(),
            25,
            150000,
            90000,
            '£'
        ) );
        mortgages.add( new Mortgage(
            '0012314235254',
            Date.today(),
            25,
            150000,
            90000,
            '£'
        ) );
        mortgages.add( new Mortgage(
            '0012314235254',
            Date.today(),
            25,
            150000,
            90000,
            '£'
        ) );
        mortgages.add( new Mortgage(
            '0012314235254',
            Date.today(),
            25,
            150000,
            90000,
            '£'
        ) );
        mortgages.add( new Mortgage(
            '0012314235254',
            Date.today(),
            25,
            150000,
            90000,
            '£'
        ) );
        mortgages.add( new Mortgage(
            '0012314235254',
            Date.today(),
            25,
            150000,
            90000,
            '£'
        ) );
        return mortgages;
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: This method gets list of the customer's investments
    * @param Id id of the customer
    * @return: List< Investment >
    */
    @RemoteAction
    global static List< Investment > getInvestments ( Id customerId ) {
        List< Investment > investments = new List< Investment >();
        investments.add( new Investment(
            'Pension Fund',
            'Gold 65 PLUS',
            35000,
            '£'
        ) );
        investments.add( new Investment(
            'Investment Fund',
            'NASDAQ Selection',
            50000,
            '£'
        ) );
        investments.add( new Investment(
            'Investment Fund',
            'NASDAQ Selection',
            50000,
            '£'
        ) );
        investments.add( new Investment(
            'Investment Fund',
            'NASDAQ Selection',
            50000,
            '£'
        ) );
        investments.add( new Investment(
            'Investment Fund',
            'NASDAQ Selection',
            50000,
            '£'
        ) );
        investments.add( new Investment(
            'Investment Fund',
            'NASDAQ Selection',
            50000,
            '£'
        ) );
        return investments;
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: This method gets chart data for chosen customer
    * @param Id id of the customer
    * @return: ChartData
    */
    @RemoteAction
    global static ChartData getChartData ( Id customerId ) {
        ChartData chartData = new ChartData();

        chartData.labels.add( 'Savings Account' );
        chartData.labels.add( 'Pension Fund' );
        chartData.labels.add( 'Investment Fund' );

        chartData.data.add( 15000 );
        chartData.data.add( 30000 );
        chartData.data.add( 55000 );

        return chartData;
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: Wrapper class for bank account
    */
    global class BankAccount {
        global String accountNumber { get; set; }
        global Decimal availableBalance { get; set; }
        global Decimal overdraft { get; set; }
        global String currencySymbol { get; set; }

        global BankAccount( String accountNumber, Decimal availableBalance, Decimal overdraft, String currencySymbol ) {
            this.accountNumber = accountNumber;
            this.availableBalance = availableBalance;
            this.overdraft = overdraft;
            this.currencySymbol = currencySymbol;
        }
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: Wrapper class for credit card
    */
    global class CreaditCard {
        global String cardNumber { get; set; }
        global Decimal cardLimit { get; set; }
        global Decimal available { get; set; }
        global String currencySymbol { get; set; }

        global CreaditCard( String cardNumber, Decimal cardLimit, Decimal available, String currencySymbol ) {
            this.cardNumber = cardNumber;
            this.cardLimit = cardLimit;
            this.available = available;
            this.currencySymbol = currencySymbol;
        }
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: Wrapper class for mortgage
    */
    global class Mortgage {
        global String mortgageNumber { get; set; }
        global Date mortgageDate { get; set; }
        global Integer term { get; set; }
        global Decimal loanAmount { get; set; }
        global Decimal amountDue { get; set; }
        global String currencySymbol { get; set; }

        global Mortgage( String mortgageNumber, Date mortgageDate, Integer term, Decimal loanAmount, Decimal amountDue, String currencySymbol ) {
            this.mortgageNumber = mortgageNumber;
            this.mortgageDate = mortgageDate;
            this.term = term;
            this.loanAmount = loanAmount;
            this.amountDue = amountDue;
            this.currencySymbol = currencySymbol;
        }
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: Wrapper class for bank investment
    */
    global class Investment {
        global String product { get; set; }
        global String description { get; set; }
        global Decimal amount { get; set; }
        global String currencySymbol { get; set; }

        global Investment( String product, String description, Decimal amount, String currencySymbol ) {
            this.product = product;
            this.description = description;
            this.amount = amount;
            this.currencySymbol = currencySymbol;
        }
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: Wrapper class for bank chart data
    */
    global class ChartData {
        global List< String > labels { get; set; }
        global List< Decimal > data { get; set; }

        global ChartData() {
            this.labels = new List< String >();
            this.data = new List< Decimal >();
        }
    }
}