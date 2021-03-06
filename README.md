# Politics_of_Sermons
Repository to analyze political communications in sermons

Much of the literature on political communication from the pulpit relies on surveys of members of the clergy and/or congregants. This approach implicitly assumes preachers and members accurately recall political content delivered during a sermon. Additionally, surveys are expensive, and often require the researcher to select one to two denominations to study at a single point in time. We lack a complete understanding of how members of the clergy across multiple denominations speak about politics. Additionally, we lack a vigorous empirical examination of how political communication from the pulpit functions as a reaction to a salient national events (i.e. legalization of same-sex marriage, presidential elections, or terrorist attacks). I gather over 150,000 sermons from across the US and across multiple denominations to test existing theories of clergy political communication with observational data. I am able to leverage the temporal aspect of these data as well as examine differences in political speech across denominations. While these data do not represent a random sample, important insights on the political life of clergy can be gained from this data source.

sermon_scrape.py utilizes the Selenium library in Python to navigate across web pages. The starting URL is the results from an "empty" search. The script collects the desired sermon URL's from each page (15 links) and stores them. The script then clicks the "Next" button to navigate to the next page. The script iterates through this process until all sermon links have been collected. 

A loop iterates through this list of links and navigates to each link. Metadata (author, date, denomination, and title) and the contents of the sermon are scraped and the text of each are stored in separate variables. Since many sermons are displayed across multiple pages, another loop is utilized to iterate through and click "Next" buttons and scrape additional sermon content on these pages.

Each text file is named "Sermon#.txt" where the "#" corresponds to a counter incremented by one each iteration through the list of URL's.

## Running scripts

1. Run three scraping files (sermon_scrapeXXXXXX.py) simultaneously (create/change directories first)
2. Run convert2json.py to save .txt files into .JSON (single file).
3. Run loadjson.R to load in .JSON file and calculate descriptive statistics.
