"
I am the ViewModel for BPMN Sequence Flows, connecting the semantic flow model to its visual diagram shape and Magritte property forms.
"
Class {
	#name : 'OPBPMNFlowViewModel',
	#superclass : 'OPBPMNAbstractFlowViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNFlowViewModel class >> modelClass [ ^ OPBPMNFlowModel
]

{ #category : 'forms' }
OPBPMNFlowViewModel >> buildEditorForm: aForm [

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Type'
		property: #type
		items: #( #Normal #Default #Conditional ).
	droplist display: [ :eachFlowType | eachFlowType asString ]
]

{ #category : 'accessing' }
OPBPMNFlowViewModel >> icon [ ^ OPBPMNIcon current sequenceFlow
]
