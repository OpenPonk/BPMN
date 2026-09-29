"
I map the underlying BPMN Data Object model to its UI representation and configure dynamic icons based on the object state.
"
Class {
	#name : 'OPBPMNDataObjectViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNDataObjectViewModel class >> modelClass [ ^ OPBPMNDataObjectModel
]

{ #category : 'forms' }
OPBPMNDataObjectViewModel >> buildEditorForm: aForm [

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Type'
		property: #type
		items: #( #DataObject #DataInput #DataOutput #DataStore ).
	droplist displayIcon: [ :eachDataType | self typeIconFor: eachDataType ].
	droplist display: [ :eachDataType | eachDataType asString ]
]

{ #category : 'accessing' }
OPBPMNDataObjectViewModel >> icon [ ^ OPBPMNIcon current dataObject16
]

{ #category : 'testing' }
OPBPMNDataObjectViewModel >> isNameMultiline [
	^ true
]

{ #category : 'forms' }
OPBPMNDataObjectViewModel >> typeIconFor: aType [

	aType = OPBPMNNodeType DataObject ifTrue: [
		^ OPBPMNIcon current dataObject16 ].
	aType = OPBPMNNodeType DataInput ifTrue: [
		^ OPBPMNIcon current dataInput16 ].
	aType = OPBPMNNodeType DataOutput ifTrue: [
		^ OPBPMNIcon current dataOutput16 ].
	aType = OPBPMNNodeType DataStore ifTrue: [
		^ OPBPMNIcon current dataStore16 ].
	self error: 'Unknown type'
]
