
from pylab import *


fig = figure()
rcParams.update({'font.size': 12})
ax = fig.add_subplot(111)

ax.set_xlabel("X axis label")
ax.set_ylabel("Y axis label")

x_series = [0,1,2,3,4,5]
y_series_1 = [x for x in x_series]
y_series_2 = [x*2 for x in x_series]
y_series_3 = [x*3 for x in x_series]
y_series_4 = [x*4 for x in x_series]

y_series_5 = [x*5 for x in x_series]
y_series_6 = [x*6 for x in x_series]
y_series_7 = [x*7 for x in x_series]
y_series_8 = [x*8 for x in x_series]

colors = ['black', 'blue', 'green', 'red', 'cyan', 'magenta', 'orange', 'purple']
styles = ['-', '--', ':', '-.']
marker = ['o', 'D', 's', '+', '*', 'd', 'v', '.']

plotSerie1 = ax.plot(x_series, y_series_1, color=colors[0], linestyle=styles[0], marker=marker[0] ,label="seeerie1")
plotSerie2 = ax.plot(x_series, y_series_2, color=colors[1], linestyle=styles[0], marker=marker[1] ,label="seeerie2")
plotSerie3 = ax.plot(x_series, y_series_3, color=colors[2], linestyle=styles[0], marker=marker[2] ,label="seeerie3")
plotSerie4 = ax.plot(x_series, y_series_4, color=colors[3], linestyle=styles[0], marker=marker[3] ,label="seeerie4")

plotSerie5 = ax.plot(x_series, y_series_5, color=colors[4], linestyle=styles[0], marker=marker[4] ,label="seeerie5")
plotSerie6 = ax.plot(x_series, y_series_6, color=colors[5], linestyle=styles[0], marker=marker[5] ,label="seeerie6")
plotSerie7 = ax.plot(x_series, y_series_7, color=colors[6], linestyle=styles[0], marker=marker[6] ,label="seeerie7")
plotSerie8 = ax.plot(x_series, y_series_8, color=colors[7], linestyle=styles[0], marker=marker[7] ,label="seeerie8")

#ax.get_xaxis().set_ticks(range(1,len(tickNames)+1))
#ax.get_xaxis().set_ticklabels(tickNames)
#axis([0,len(tickNames)+1,0.0,1.0])

# Legend
#legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3, ncol=8, borderaxespad=0.)

#box = ax.get_position()
#ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
#ax.legend(loc='lower left', bbox_to_anchor=(1.0, 0.48))

box = ax.get_position()
ax.set_position([box.x0, box.y0 - 0.025, box.width, box.height])
legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3, ncol=4, mode="expand", borderaxespad=0.)

# Saving Figure
fig.savefig("errorplot.png", format="png", dpi=300)

