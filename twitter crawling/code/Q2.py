import urllib
import httplib
import json
import datetime, time

counts = [0]*5
def getTweets(start_date, increment, hashtag,index):
    print(start_date)
    end_date = start_date + datetime.timedelta(seconds = increment)
    print(end_date)
    mintime = int(time.mktime(start_date.timetuple()))
    maxtime = int(time.mktime(end_date.timetuple()))

    API_KEY = '09C43A9B270A470B8EB8F2946A9369F3'
    host = 'api.topsy.com'
    url = '/v2/content/tweets.json'

    #########   set query parameters
    params = urllib.urlencode({'apikey' : API_KEY, 'q' : hashtag,
                          'mintime': str(mintime), 'maxtime': str(maxtime),
                          'new_only': '1', 'include_metrics':'1', 'limit': 500})



    #########   create and send HTTP request
    req_url = url + '?' + params
    req = httplib.HTTPConnection(host)
    req.putrequest("GET", req_url)
    req.putheader("Host", host)
    req.endheaders()
    req.send('')


    #########   get response and print out status
    resp = req.getresponse()
    print (resp.status, resp.reason)


    #########   extract tweets
    resp_content = resp.read()
    ret = json.loads(resp_content.decode())
    tweets = ret['response']['results']['list']
    print(tweets.__len__())
    if(tweets.__len__() == 500):
        getTweets(start_date,increment/2,hashtag,index);
        getTweets((start_date + datetime.timedelta(seconds = increment/2)),increment/2,hashtag,index);
    else:
        with open('search_log.txt','a') as logfile:
            with open('tweets1.txt','a') as outfile:
                for tweet in tweets:
                    #outfile.write(tweet)
                    json.dump(tweet, outfile)
                    outfile.write('\n')
            logstr = "Hashtag: "+hashtag+"\nFrom: "+start_date.ctime()+"\nTo: "+end_date.ctime()+"\nNo. of Results: "+str(tweets.__len__())
            counts[index] = counts[index]+tweets.__len__()
            logfile.write(logstr)
            logfile.write('\n\n')
    return;
#########   create UNIX timestamps

hashs=['#brandbowl','#SB49','#football','#MakeSafeHappen','#adbowl'];
maxcount = [0]*5
for j in range(0,4):
    start_date = datetime.datetime(2015,2,1, 16,0,0)
    temp = hashs[j]
    getTweets(start_date,3600,temp,j);

lines_seen = set() 
outfile = open('tweets.txt', "w")
for line in open('tweets1.txt', "r"):
    if line not in lines_seen: 
        outfile.write(line)
        lines_seen.add(line)
outfile.close()
print counts
