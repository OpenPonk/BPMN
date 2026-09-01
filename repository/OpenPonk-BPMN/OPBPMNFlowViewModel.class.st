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

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Normal #Default #Conditional );
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self modelChanged ].
]

{ #category : 'accessing' }
OPBPMNFlowViewModel >> icon [ ^ OPBPMNIcon current sequenceFlow
]
