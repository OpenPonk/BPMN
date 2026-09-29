"
I am a validation rule verifying that standard flow nodes have at least one incoming sequence flow, ensuring the process path is reachable.
"
Class {
	#name : 'AN01FlowNodeIncomingFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN01FlowNodeIncomingFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'verification' }
AN01FlowNodeIncomingFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifTrue: [ 
		(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifFalse: [ 
			counter := 0.
			aVerifiedObject incoming do: [ :each | 
				(each isKindOf: OPBPMNFlowModel) ifTrue: [ counter := 1 ] ] ].
		(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType Link ifTrue: [ 
				counter := 1 ] ].
		counter = 0 ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(AN01) ' , aVerifiedObject class name
					   , ' must have incoming Sequence Flow.') } ] ].
	^ {  }
]
