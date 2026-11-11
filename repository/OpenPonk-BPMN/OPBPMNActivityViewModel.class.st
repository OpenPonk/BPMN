"
I am the ViewModel for BPMN Activities (such as Tasks and SubProcesses). I connect the underlying activity model to the editor's visual shapes and property forms.
"
Class {
	#name : 'OPBPMNActivityViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNActivityViewModel class >> modelClass [ ^ OPBPMNActivityModel
]

{ #category : 'forms' }
OPBPMNActivityViewModel >> buildEditorForm: aForm [

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm bindDroplist: 'Type' property: #type items: #( #Service #User #Manual #Send #Receive #None ).
	droplist displayIcon: [ :eachType | self typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	aForm bindCheckbox: 'Is Call Activity?' property: #isCallActivity.
	(self model type = OPBPMNNodeType Service or: [ self model type = OPBPMNNodeType Send ]) ifFalse: [ ^ self ].
	aForm bindTextInput: 'Executable attribute' property: #executableAttribute.
	aForm bindTextInput: 'Executable attribute value' property: #executableAttributeValue
]

{ #category : 'accessing' }
OPBPMNActivityViewModel >> icon [ ^ OPBPMNIcon current activity
]

{ #category : 'testing' }
OPBPMNActivityViewModel >> isNameMultiline [
	^ true
]

{ #category : 'accessing' }
OPBPMNActivityViewModel >> structuralPropertySelectors [
	^ #( #type )
]

{ #category : 'forms' }
OPBPMNActivityViewModel >> typeIconFor: aType [
	aType = OPBPMNNodeType Service ifTrue: [
		^ OPBPMNIcon current activityService ].
	aType = OPBPMNNodeType User ifTrue: [
		^ OPBPMNIcon current activityUser ].
	aType = OPBPMNNodeType Manual ifTrue: [
		^ OPBPMNIcon current activityManual ].
	aType = OPBPMNNodeType Send ifTrue: [
		^ OPBPMNIcon current activitySend ].
	aType = OPBPMNNodeType Receive ifTrue: [
		^ OPBPMNIcon current activityReceive ].
	aType = OPBPMNNodeType None ifTrue: [
		^ OPBPMNIcon current activityNone ].
	^ super typeIconFor: aType
]
