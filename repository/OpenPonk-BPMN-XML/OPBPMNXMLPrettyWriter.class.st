Class {
	#name : 'OPBPMNXMLPrettyWriter',
	#superclass : 'XMLPrettyPrintingWriterFormatter',
	#instVars : [
		'lineBreak'
	],
	#category : 'OpenPonk-BPMN-XML-Writer',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'Writer'
}

{ #category : 'accessing' }
OPBPMNXMLPrettyWriter >> lineBreak: aCharacterOrString [
	lineBreak := aCharacterOrString asString
]

{ #category : 'writing' }
OPBPMNXMLPrettyWriter >> writeLineBreak [

	self writer atBeginning ifTrue: [ ^ self ].
	self writer nextPutAll: lineBreak.
	self currentIndentLevel isZero ifTrue: [ ^ self ].
	self indentString ifEmpty: [ ^ self ].
	self writeIndent
]

{ #category : 'accessing' }
OPBPMNXMLPrettyWriter >> writer: aWriter [
	super writer: aWriter.
	lineBreak ifNil: [ lineBreak := aWriter lineBreak ]
]
