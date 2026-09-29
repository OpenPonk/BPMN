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

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Type'
		property: #type
		items: #( #'Exclusive (empty)' #Exclusive #Inclusive #Parallel #Complex #Eventbased ).
	droplist displayIcon: [ :eachGatewayType | self model typeIconFor: eachGatewayType ].
	droplist display: [ :eachGatewayType | eachGatewayType asString ]
]

{ #category : 'accessing' }
OPBPMNGatewayViewModel >> icon [ ^ OPBPMNIcon current gateway
]
