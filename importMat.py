import numpy as np 
import os
import scipy as sp 
import scipy.io as spo

def importMat(filename):
	matFile = spo.loadmat(filename)
	return matFile

def saveMat(filename, dict0):
	spo.savemat(filename, dict0)


def loadData():
	subject1testingData = importMat('subject1testingData.mat')
	subject2testingData = importMat('subject2testingData.mat')
	subject3testingData = importMat('subject3testingData.mat')

	subject1trainingData = importMat('subject1trainingData.mat')
	subject2trainingData = importMat('subject2trainingData.mat')
	subject3trainingData = importMat('subject3trainingData.mat')

	subject1gloveData = importMat('subject1gloveData.mat')
	subject2gloveData = importMat('subject2gloveData.mat')
	subject3gloveData = importMat('subject3gloveData.mat')

if __name__ == '__loadData__':
	loadData()
