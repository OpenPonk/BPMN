Class {
	#name : 'OPBPMNGatewayController',
	#superclass : 'OPBPMNElementController',
	#instVars : [
		'iconElement',
		'iconConstraint'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNGatewayController >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Exclusive #Inclusive #Parallel #Complex #Eventbased );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue | 
			self model type: newValue.
			self diagramElement modelChanged ]
]

{ #category : 'connecting' }
OPBPMNGatewayController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBPMNFlowController
]

{ #category : 'connecting' }
OPBPMNGatewayController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPBPMNFlowController)
		
]

{ #category : 'construction' }
OPBPMNGatewayController >> diagramElementClass [

	^ OPBPMNGatewayShape 
]

{ #category : 'accessing' }
OPBPMNGatewayController >> modelClass [
	^ OPBPMNGatewayModel
]

{ #category : 'connecting' }
OPBPMNGatewayController >> typeIconForModel [
	^ self model typeIconFor: self model type
]
