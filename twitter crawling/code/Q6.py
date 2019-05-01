import json

with open('tweets.txt', 'r') as infile:
    with open('Output - Q6.txt','w') as outfile:
        for line in infile.readlines():
            text = json.loads(line)
            outfile.write('Tweet Post Date: '+str(text['firstpost_date'])+', Text: '+text['title'].encode('UTF-8', 'replace')+', Number of retweets: '+str(text['tweet']['retweet_count'])+', User: '+text['tweet']['user']['screen_name'].encode('UTF-8', 'replace'))
                    #print text['tweet']['user']['screen_name']
            outfile.write('\n')
        outfile.close()
infile.close()