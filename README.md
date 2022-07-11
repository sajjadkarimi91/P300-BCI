# P300-classification-methods

A MATLAB toolbox for P300 Classification in EEG-based BCI system with Bayes LDA, SVM, LassoGLM and a Deep CNN methods

Codes and data for the following paper are extended to different methods:

An efficient P300-based brain-computer interface for disabled subjects


## 1. Introduction.

This package includes the prototype MATLAB codes for P300-based brain-computer interfaces.

The implemented methodes include: 

  1. Bayesian linear discriminant analysis (Bayes-LDA)
  2. Support-vector machines (SVMs)       
  3. Penalized generalized linear models (LassoGLM)
  4. Deep Convolutional Neural Networks (Deep-CNNs) 

     


## 2. Usage & Dependency.

## Dependency:
     https://www.epfl.ch/labs/mmspg/research/page-58317-en-html/bci-2/bci_datasets/
     
     https://github.com/lrkrol/plot_erp

## Usage:
Run "p300_pattern.m" to analyze the P300 ERP over baseline events.

Run "p300_classifiers.m" to have a P300-BCI system with different classifiers and performances.
