"
I map the underlying BPMN Boundary Event model to its UI representation and Magritte property forms.
"
Class {
	#name : 'OPBPMNBoundaryEventViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNBoundaryEventViewModel class >> modelClass [ ^ OPBPMNBoundaryEventModel
]

{ #category : 'forms' }
OPBPMNBoundaryEventViewModel >> buildEditorForm: aForm [

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Type'
		property: #type
		items:
			#( #Receive #Timer #Escalation #Conditional #Error #Cancel #CatchCompensation
			   #Signal #Multiple #ParallelMultiple ).
	droplist displayIcon: [ :eachType | self model typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	aForm bindCheckbox: 'Is Non-Interrupting' property: #isNonInterrupting
]

{ #category : 'accessing' }
OPBPMNBoundaryEventViewModel >> icon [ ^ OPBPMNIcon current intermediateEvent
]
