"
I map the underlying BPMN End Event model to its UI representation and Magritte property forms.
"
Class {
	#name : 'OPBPMNEndEventViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNEndEventViewModel class >> modelClass [ ^ OPBPMNEndEventModel
]

{ #category : 'forms' }
OPBPMNEndEventViewModel >> buildEditorForm: aForm [
	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Type'
		property: #type
		items:
			#( #Send #EscalationThrow #Error #Cancel #CompensationThrow
			   #SignalThrow #MultipleThrow #Terminate #None ).
	droplist displayIcon: [ :eachType | self model typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	self model type = OPBPMNNodeType Send ifTrue: [
		aForm bindTextInput: 'Executable attribute' property: #executableAttribute.
		aForm bindTextInput: 'Executable attribute value' property: #executableAttributeValue ]
]

{ #category : 'accessing' }
OPBPMNEndEventViewModel >> icon [ ^ OPBPMNIcon current endEvent
]

{ #category : 'accessing' }
OPBPMNEndEventViewModel >> structuralPropertySelectors [
	^ #( #type )
]
