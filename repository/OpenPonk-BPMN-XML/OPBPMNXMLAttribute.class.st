Class {
	#name : #OPBPMNXMLAttribute,
	#superclass : #OPBPMNXMLInfoItems,
	#instVars : [
		'xmlName'
	],
	#category : #'OpenPonk-BPMN-XML-DOM'
}

{ #category : #testing }
OPBPMNXMLAttribute >> isAttribute [
	^ true
]

{ #category : #accessing }
OPBPMNXMLAttribute >> xmlName [
	^ xmlName
]

{ #category : #accessing }
OPBPMNXMLAttribute >> xmlName: aString [
	xmlName := aString
]
