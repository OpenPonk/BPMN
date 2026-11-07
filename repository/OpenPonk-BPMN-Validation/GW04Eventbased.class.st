"
I am a validation rule verifying the structural constraints of Event-Based Gateways, such as ensuring their outgoing flows connect only to catching events or receive tasks.
"
Class {
	#name : 'GW04Eventbased',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
GW04Eventbased class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : 'verification' }
GW04Eventbased >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| outgoingSequenceFlows allowedEventTypes targetNodes hasInvalidTarget hasReceiveTask hasMessageEvent hasReceiveTaskWithBoundary |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Eventbased ifFalse: [ ^ {  } ].
	outgoingSequenceFlows := aVerifiedObject outgoing select: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	outgoingSequenceFlows ifEmpty: [ ^ {  } ].
	allowedEventTypes := {
		OPBPMNNodeType Receive .
		OPBPMNNodeType Timer .
		OPBPMNNodeType Conditional .
		OPBPMNNodeType Signal .
		OPBPMNNodeType Multiple .
		OPBPMNNodeType ParallelMultiple }.
	targetNodes := outgoingSequenceFlows collect: #target.
	hasInvalidTarget := targetNodes anySatisfy: [ :targetNode |
		((targetNode isKindOf: OPBPMNIntermediateEventModel) and: [
			allowedEventTypes includes: targetNode type ]) not and: [
			((targetNode isKindOf: OPBPMNActivityModel) and: [
				targetNode type = OPBPMNNodeType Receive ]) not ] ].
	hasInvalidTarget ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(GW04) ' , aVerifiedObject class name
				, ' can have on outgoing flows only Intermediate Catching Events or Receive Task.') } ].
	hasReceiveTask := targetNodes anySatisfy: [ :targetNode |
		(targetNode isKindOf: OPBPMNActivityModel) and: [
			targetNode type = OPBPMNNodeType Receive ] ].
	hasMessageEvent := targetNodes anySatisfy: [ :targetNode |
		(targetNode isKindOf: OPBPMNIntermediateEventModel) and: [
			targetNode type = OPBPMNNodeType Receive ] ].
	(hasReceiveTask and: [ hasMessageEvent ]) ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(GW04) ' , aVerifiedObject class name
				, ' cannot mix Receive Task and Message Intermediate Event on outgoing flows.') } ].
	hasReceiveTaskWithBoundary := targetNodes anySatisfy: [ :targetNode |
		(targetNode isKindOf: OPBPMNActivityModel) and: [
			targetNode type = OPBPMNNodeType Receive and: [
				targetNode elements anySatisfy: [ :eachChild |
					eachChild isKindOf: OPBPMNBoundaryEventModel ] ] ] ].
	hasReceiveTaskWithBoundary ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(GW04) Receive Task connected to ' , aVerifiedObject class name
				, ' cannot have attached Boundary Events.') } ].
	^ {  }
]
