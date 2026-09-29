"
I represent a basic XML element node within the BPMN XML DOM tree structure. I manage the element's qualified XML name and basic writing behavior.
"
Class {
	#name : 'OPBPMNXMLElement',
	#superclass : 'OPBPMNXMLInfoItems',
	#instVars : [
		'xmlName'
	],
	#category : 'OpenPonk-BPMN-XML-DOM',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'DOM'
}

{ #category : 'testing' }
OPBPMNXMLElement >> isElement [
	^ true
]

{ #category : 'writing' }
OPBPMNXMLElement >> writeXMLOn: aWriter [
	aWriter tag: self xmlName
]

{ #category : 'accessing' }
OPBPMNXMLElement >> xmlName [
	^ xmlName
]

{ #category : 'accessing' }
OPBPMNXMLElement >> xmlName: aString [
	xmlName := aString
]
