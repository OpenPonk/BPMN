Class {
	#name : 'OPBPMNFlowController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNFlowController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Normal #Default #Conditional );
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self modelChanged ].
]

{ #category : 'construction' }
OPBPMNFlowController >> diagramElementClass [

	^ OPBPMNFlowShape
]

{ #category : 'accessing' }
OPBPMNFlowController >> modelClass [
	^ OPBPMNFlowModel
]
