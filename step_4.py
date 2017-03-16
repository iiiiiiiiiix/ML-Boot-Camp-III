import numpy as np
import pandas as pd
import xgboost as xgb

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import StratifiedKFold

path = 'C:/Users/admin/Downloads/'

# вторая модель
X = pd.read_csv(path + 'new_train.csv')
test = pd.read_csv(path + 'new_test.csv')

path = 'C:/Users/admin/Dropbox/docs/Data/ml-boot-camp/files/'
y = pd.read_csv(path + 'y_train.csv', sep=';', names=['result'])
y = np.ravel(y)

clf1 = xgb.XGBClassifier(learning_rate=0.1, subsample=0.5, seed=16)
cv = StratifiedKFold(n_splits=5, random_state=5, shuffle=True)
scores = cross_val_score(clf1, X, y, cv=cv, scoring='neg_log_loss')
np.mean(scores*(-1))
# 0.38082500136422004
clf1.fit(X, y)
y_pred = clf1.predict_proba(test)
pred2 = y_pred[:, 1]
np.savetxt('C:/Users/admin/Downloads/xgb2.csv', pred2, delimiter=",", newline='\n\n')
