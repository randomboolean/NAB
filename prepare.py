import os
import sys
import requests

#theta2 = 0.5126953125
#theta1 = theta2 * 0.8

#theta2 = 0.650769042969
#theta1 = 0.5126953125

theta2 = 0.8
theta1 = theta2 * 0.95


w1 = 1.0 / (theta2 - theta1)
w2 = 1 - w1

w1 = w1 / 10
w2 = w2 / 10

pre = 0
template = open('template.mc2').read().strip()

detector = sys.argv[1]
dir = os.path.join('results', detector)
dir2 = os.path.join('results2',detector)
for folder in os.listdir(dir):
  if not('.' in folder):
    subdir = os.path.join(dir, folder)
    subdir2 = os.path.join(dir2, folder)
    if not os.path.exists(subdir2):
      os.makedirs(subdir2)
    for file in os.listdir(subdir):
      filepath = os.path.join(subdir, file)
      filepath2 = os.path.join(subdir2, file)
      print("processing " + filepath)
      
      # fill and post the warpscript template
      mc2 = template.replace('@csvContent@', open(filepath).read().strip())
      mc2 = mc2.replace('@w1@', str(w1))
      mc2 = mc2.replace('@w2@', str(w2))
      mc2 = mc2.replace('@theta1@', str(theta1))
      mc2 = mc2.replace('@theta2@', str(theta2))
      mc2 = mc2.replace('@pre@', str(pre))
      ans = requests.post('https://sandbox.senx.io/api/v0/exec', mc2)

      # save the result
      open(filepath2, 'w').write(ans.json()[0])
