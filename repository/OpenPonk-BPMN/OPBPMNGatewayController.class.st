"
I am the controller for BPMN Gateways. I manage canvas interactions and enforce valid connection rules for branching and merging sequence flows.
"
Class {
	#name : 'OPBPMNGatewayController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNGatewayController class >> diagramElementClass [

	^ OPBPMNGatewayShape 
]

{ #category : 'accessing' }
OPBPMNGatewayController class >> viewModelClass [
	^ OPBPMNGatewayViewModel
]

{ #category : 'connecting' }
OPBPMNGatewayController >> canBeSourceFor: aController [

	^ (aController isKindOf: OPBPMNFlowController) or: [
		  aController isKindOf: OPBPMNAssociationController ]
]

{ #category : 'connecting' }
OPBPMNGatewayController >> canBeTargetFor: aController [

	^ ((aController isKindOf: OPBPMNFlowController) or: [
		   aController isKindOf: OPBPMNAssociationController ]) and: [
		  aController source ~= self ]
]
