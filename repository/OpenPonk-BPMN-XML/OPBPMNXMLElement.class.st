Class {
	#name : #OPBPMNXMLElement,
	#superclass : #OPBPMNXMLInfoItems,
	#instVars : [
		'xmlName'
	],
	#category : #'OpenPonk-BPMN-XML-DOM'
}

{ #category : #testing }
OPBPMNXMLElement >> isElement [
	^ true
]

{ #category : #writing }
OPBPMNXMLElement >> writeXMLOn: aWriter [
	aWriter tag: self xmlName
]

{ #category : #accessing }
OPBPMNXMLElement >> xmlName [
	^ xmlName
]

{ #category : #accessing }
OPBPMNXMLElement >> xmlName: aString [
	xmlName := aString
]
