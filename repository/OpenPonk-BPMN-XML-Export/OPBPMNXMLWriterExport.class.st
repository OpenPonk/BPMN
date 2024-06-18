Class {
	#name : 'OPBPMNXMLWriterExport',
	#superclass : 'Object',
	#instVars : [
		'unresolved',
		'identityCache',
		'classPrefix',
		'stereotypes',
		'umlMetamodel'
	],
	#category : 'OpenPonk-BPMN-XML-Export-Writer',
	#package : 'OpenPonk-BPMN-XML-Export',
	#tag : 'Writer'
}

{ #category : 'instance creation' }
OPBPMNXMLWriterExport class >> toString: aModel [
	^ OPBPMNXMLWriter writeToString: (self new write: aModel)
]

{ #category : 'initialization' }
OPBPMNXMLWriterExport >> initialize [
	super initialize.
	unresolved := OrderedCollection new.
	identityCache := Dictionary new.
	classPrefix := self defaultClassPrefix.
	stereotypes := OrderedCollection new.
	umlMetamodel := OPBPMNSpecsStorage umlMetamodel
]
