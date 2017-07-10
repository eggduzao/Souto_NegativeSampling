from pylab import *

data = [[0.1,0.2,0.3,0.4,0.5,19,-10], [11,12,13,14,15,19,-8], [1,2,3,4,5,19,-10]]
data2 = [[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1], [.15,.1,.18,.21,.24,.26,.31,.37,.41,.36,.42,.32,.5,.44,.35,.28,.31,.21,.34,.25],
         [.22,.21,.26,.33,.27,.38,.41,.33,.46,.39,.24,.17,.21,.38,.19,.16,.14,.13,.28,.38,.25,.34,.9]]

fig = figure()
ax = fig.add_subplot(111)

ax.yaxis.grid(True, linestyle='-', which='major', color='lightgrey', alpha=0.5)
ax.set_axisbelow(True)

bp = boxplot(data)

plt.setp(bp['medians'], color='green')
plt.setp(bp['caps'], color='black')
plt.setp(bp['boxes'], color='blue')
plt.setp(bp['whiskers'], color='orange')
plt.setp(bp['fliers'], color='red', marker='o', markersize = 5)

ax.get_xaxis().set_ticks([1,2,3])
ax.get_xaxis().set_ticklabels(['first', 'second', 'third'])

fig.savefig("foo.png", format="png", dpi=300)
