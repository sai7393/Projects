import urllib
import httplib
import json
import datetime, time
import numpy as np
import pylab as pl
import matplotlib.pyplot as pyplot
from numpy import polyfit
import math
import warnings
warnings.simplefilter('ignore', np.RankWarning)

# getting max number of retweets
length=0
with open('tweets.txt','r') as ifile:
	for line in ifile.readlines():
		tweet = json.loads(line)
		if not tweet['tweet']['retweeted']:
			length = max(length,tweet['tweet']['retweet_count'])

ifile.close()

# updating retweets count array
array=[0]*(length+1)
xaxis = [0]*(length+1)
npx = np.zeros(length+1)
with open('tweets.txt','r') as infile:
	for line in infile.readlines():
		tweet = json.loads(line)
		if not tweet['tweet']['retweeted']:
			i = tweet['tweet']['retweet_count']
			array[i] = array[i]+1
			xaxis[i] = i
			npx[i] = i

infile.close()

# plotting the linear graph
pl.plot(xaxis,array)
pl.plot(xaxis,array,'ro')
p = np.polyfit(xaxis,array,1)
pl.plot(npx,p[0]*npx + p[1])
pl.axis([-100,600,-10000,100000])
pl.xlabel("k")
pl.ylabel("Number of tweets retweeted k times")
pl.title("Linear Scale Graph")
pl.show()

# plotting the loglog graph
fig = pyplot.figure()
ax = fig.add_subplot(1,1,1)
pyplot.xlabel("k")
pyplot.ylabel("Number of tweets retweeted k times")
pyplot.title("Log-log Scale Graph")
ax.set_yscale('log')
ax.set_xscale('log')
ax.plot(xaxis,array,'ro')
pyplot.show()