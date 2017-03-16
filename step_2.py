import numpy as np
import pandas as pd
import xgboost as xgb

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import StratifiedKFold
from sklearn.model_selection import GridSearchCV

import time

path = 'C:/Users/admin/Downloads/'

X = pd.read_csv(path + 'train.csv')
test = pd.read_csv(path + 'test.csv')

path = 'C:/Users/admin/Dropbox/docs/Data/ml-boot-camp/files/'
y = pd.read_csv(path + 'y_train.csv', sep=';', names=['result'])
y = np.ravel(y)

# первая модель
clf = xgb.XGBClassifier(learning_rate=0.1, seed=16)


def tuning(model):
    start_time = time.time()
    subsample = np.linspace(0.1, 0.95, 18)
    param_grid = dict(subsample=subsample)
    cv = StratifiedKFold(n_splits=5, random_state=5, shuffle=True)
    grid_search = GridSearchCV(model, param_grid, scoring="neg_log_loss", n_jobs=-1, cv=cv)
    grid_result = grid_search.fit(X, y)
    minutes = (time.time() - start_time)/60
    print("%.2f minutes" % minutes)
    print("Best: %.12f using %s" % (grid_result.best_score_*(-1), grid_result.best_params_))

tuning(clf)
# Best: 0.380165 using {'subsample': 0.6}

clf = xgb.XGBClassifier(learning_rate=0.1, subsample=0.6, seed=16)


def accuracy(model):
    start_time = time.time()
    my_list = []
    for i in range(100):
        model.set_params(seed=16 + i)
        cv = StratifiedKFold(n_splits=5, random_state=5, shuffle=True)
        scores = cross_val_score(model, X, y, cv=cv, scoring='neg_log_loss')
        my_list.append(np.mean(scores * (-1)))
    mean = sum(my_list) / len(my_list)
    minutes = (time.time() - start_time)/60
    print("%.2f minutes" % minutes)
    print("avg_accuracy: %.12f" % mean)

accuracy(clf)
# 0.380973346501


def prediction(model):
    start_time = time.time()
    my_list = []
    for i in range(100):
        model.set_params(seed=16 + i)
        model.fit(X, y)
        y_pred = model.predict_proba(test)
        pred = y_pred[:, 1]
        my_list.append(pred)
    mean = sum(my_list) / len(my_list)
    minutes = (time.time() - start_time)/60
    print("%.2f minutes" % minutes)
    return mean

p = prediction(clf)
np.savetxt('C:/Users/admin/Downloads/xgb1.csv', p, delimiter=",", newline='\n\n')
