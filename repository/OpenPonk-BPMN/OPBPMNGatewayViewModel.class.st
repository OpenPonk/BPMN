"
I map the underlying BPMN Gateway model to its UI representation and configure form properties for branching logic.
"
Class {
	#name : 'OPBPMNGatewayViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNGatewayViewModel class >> modelClass [ ^ OPBPMNGatewayModel
]

{ #category : 'forms' }
OPBPMNGatewayViewModel >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #'Exclusive (empty)' #Exclusive #Inclusive #Parallel #Complex #Eventbased );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
			self model type: newValue.
			self modelChanged ]
]

{ #category : 'accessing' }
OPBPMNGatewayViewModel >> icon [ ^ OPBPMNIcon current gateway
]
