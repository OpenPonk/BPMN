Class {
	#name : #OPBPMNXMLPrettyWriter,
	#superclass : #XMLPrettyPrintingWriterFormatter,
	#instVars : [
		'lineBreak'
	],
	#category : #'OpenPonk-BPMN-XML-Writer'
}

{ #category : #accessing }
OPBPMNXMLPrettyWriter >> lineBreak: aCharacterOrString [
	lineBreak := aCharacterOrString asString
]

{ #category : #accessing }
OPBPMNXMLPrettyWriter >> writeLineBreak [
	self writer atBeginning
		ifFalse: [ self writer nextPutAll: lineBreak.
			(self currentIndentLevel > 0 and: [ self indentString size > 0 ])
				ifTrue: [ self writeIndent ] ]
]

{ #category : #accessing }
OPBPMNXMLPrettyWriter >> writer: aWriter [
	super writer: aWriter.
	lineBreak ifNil: [ lineBreak := aWriter lineBreak ]
]
