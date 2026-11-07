"
Validates pairing of intermediate link events within the same process or subprocess scope. Ensures that each throwing link event matches a single catching link event with the same non-empty label, and each catching link event has at least one corresponding throwing link event.
"
Class {
	#name : 'IE05LinkEventPairing',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
IE05LinkEventPairing class >> validateClass [
	^ OPBPMNIntermediateEventModel
]

{ #category : 'private' }
IE05LinkEventPairing >> scopeElementsFor: aNodeModel [
	| ownerNode enclosingScope |
	ownerNode := aNodeModel owner.
	ownerNode ifNil: [ ^ { aNodeModel } ].
	(ownerNode isKindOf: OPBPMNSubProcessModel) ifTrue: [
		^ ownerNode elements ].
	enclosingScope := aNodeModel enclosingPool.
	(enclosingScope isKindOf: OPBPMNPoolModel) ifTrue: [
		^ (enclosingScope elements reject: [ :eachChild | eachChild isKindOf: OPBPMNLaneModel ])
			, (enclosingScope lanes flatCollect: [ :eachLane | eachLane elements ]) ].
	(enclosingScope isKindOf: OPBPMNModel) ifTrue: [
		^ enclosingScope nodes ].
	^ ownerNode elements
]

{ #category : 'verification' }
IE05LinkEventPairing >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| trimmedName scopeNodes matchingCatches matchingThrows |
	(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject type = OPBPMNNodeType LinkThrow
		or: [ aVerifiedObject type = OPBPMNNodeType Link ]) ifFalse: [ ^ {  } ].
	trimmedName := aVerifiedObject name ifNil: [ '' ] ifNotNil: [ :rawName | rawName trimBoth ].
	trimmedName ifEmpty: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(IE05) ' , aVerifiedObject class name
				, ' of Link type must have a non-empty name for pairing.') } ].
	scopeNodes := self scopeElementsFor: aVerifiedObject.
	matchingCatches := scopeNodes select: [ :eachNode |
		(eachNode isKindOf: OPBPMNIntermediateEventModel) and: [
			eachNode type = OPBPMNNodeType Link and: [
				eachNode name isNotNil and: [ eachNode name trimBoth = trimmedName ] ] ] ].
	matchingThrows := scopeNodes select: [ :eachNode |
		(eachNode isKindOf: OPBPMNIntermediateEventModel) and: [
			eachNode type = OPBPMNNodeType LinkThrow and: [
				eachNode name isNotNil and: [ eachNode name trimBoth = trimmedName ] ] ] ].
	aVerifiedObject type = OPBPMNNodeType LinkThrow ifTrue: [
		matchingCatches size = 1 ifTrue: [ ^ {  } ].
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(IE05) ' , aVerifiedObject class name
				, ' of LinkThrow type must have exactly one matching Catch Link Event in the same scope.') } ].
	(matchingThrows isNotEmpty and: [ matchingCatches size = 1 ]) ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(IE05) ' , aVerifiedObject class name
			, ' of Catch Link type must have a unique name and at least one matching Throw Link Event in the same scope.') }
]
