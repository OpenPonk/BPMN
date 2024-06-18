Class {
	#name : 'OPBPMNXMLInfoItems',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-XML-DOM',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'DOM'
}

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isAttribute [
	^ false
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isElement [
	^ false
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isObjectElement [
	^ false
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isReferenceAttribute [
	^ false
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isReferenceElement [
	^ false
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isReferenceItem [
	^ self isReferenceAttribute | self isReferenceElement
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isValueAttribute [
	^ false
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isValueElement [
	^ false
]

{ #category : 'testing' }
OPBPMNXMLInfoItems >> isValueItem [
	^ self isValueAttribute | self isValueElement
]
