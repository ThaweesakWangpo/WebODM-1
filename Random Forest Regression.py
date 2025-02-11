import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import csv
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score,mean_squared_error
import seaborn as sns

#Upload and read Plant Height file
df = pd.read_csv("MSH_Weight.csv")
df

#Reshape x and y value
x = df.x.values.reshape(-1, 1)
y = df.y.values.reshape(-1, 1)

#Split train=70% and test=30%, random_state =7 
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.30, random_state=7)

#Accuracy train and test of RandomForestRegressor
RandomForestRegModel  = RandomForestRegressor()
RandomForestRegModel.fit(x_train,y_train)
print('accuracy train:',RandomForestRegModel.score(x_train,y_train))
yp=RandomForestRegModel.predict(x_test)
print('accuracy test:',RandomForestRegModel.score(x_test,y_test))

#Upload and read plant height file for predict
ph = pd.read_csv("MSH1x1m.csv")
ph

#Reshape plant height file
data = ph.MSH.values.reshape(-1, 1)
data

#Predict plant height by  RandomForestRegModel
pd = RandomForestRegModel.predict(data)
output  = pd.reshape(-1,1)
output

#Write weight file 
with open('Weight.csv', mode='w') as weight_file:
  writer = csv.writer(weight_file, delimiter=',')
  for row in output:
    writer.writerow([row])

# Root mean square error
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
rmse

# R-square
r = r2_score(y_test, y_pred)
r

# Create graph
X_grid = np.arange(min(X),max(X),0.01)
X_grid = X_grid.reshape(len(X_grid),1) 
plt.scatter(X,y, color='red') 
plt.title("Random Forest Regression")
plt.xlabel('Observed AFW (kg m^-2)')
plt.ylabel('Fitted AFW (kg m^-2)')
plt.show()

