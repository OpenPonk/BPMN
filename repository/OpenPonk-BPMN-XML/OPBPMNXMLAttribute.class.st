Class {
	#name : 'OPBPMNXMLAttribute',
	#superclass : 'OPBPMNXMLInfoItems',
	#instVars : [
		'xmlName'
	],
	#category : 'OpenPonk-BPMN-XML-DOM',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'DOM'
}

{ #category : 'testing' }
OPBPMNXMLAttribute >> isAttribute [
	^ true
]

{ #category : 'accessing' }
OPBPMNXMLAttribute >> xmlName [
	^ xmlName
]

{ #category : 'accessing' }
OPBPMNXMLAttribute >> xmlName: aString [
	xmlName := aString
]
