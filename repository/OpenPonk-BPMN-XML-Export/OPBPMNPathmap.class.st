Class {
	#name : 'OPBPMNPathmap',
	#superclass : 'Object',
	#instVars : [
		'mapping'
	],
	#category : 'OpenPonk-BPMN-XML-Export-Utility',
	#package : 'OpenPonk-BPMN-XML-Export',
	#tag : 'Utility'
}

{ #category : 'adding' }
OPBPMNPathmap >> add: aPath [
	self add: aPath retrieveUsing: [ OPBPMNSpecsStorage current at: aPath ]
]

{ #category : 'adding' }
OPBPMNPathmap >> add: aPath retrieveUsing: aBlock [
	mapping at: aPath put: aBlock value
]

{ #category : 'adding' }
OPBPMNPathmap >> initialize [
	super initialize.
	mapping := OrderedDictionary new
]

{ #category : 'adding' }
OPBPMNPathmap >> mapping [
	^ mapping
]
