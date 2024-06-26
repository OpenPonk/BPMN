Class {
	#name : 'OPBPMNSpecsStorage',
	#superclass : 'Object',
	#instVars : [
		'storage'
	],
	#classVars : [
		'Current'
	],
	#category : 'OpenPonk-BPMN-XML-Export-Utility',
	#package : 'OpenPonk-BPMN-XML-Export',
	#tag : 'Utility'
}

{ #category : 'accessing' }
OPBPMNSpecsStorage class >> current [
	"
	Current := nil
	"
	^ Current ifNil: [ Current := self new ]
]

{ #category : 'initialization' }
OPBPMNSpecsStorage >> initialize [
	super initialize.
	storage := Dictionary new
]
