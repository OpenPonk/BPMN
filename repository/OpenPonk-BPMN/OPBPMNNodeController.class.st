Class {
	#name : 'OPBPMNNodeController',
	#superclass : 'OPElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPBPMNNodeController >> dependentElements [

	^ self model edges asSet
]
