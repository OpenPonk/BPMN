Class {
	#name : #OPBPMNFactory,
	#superclass : #Object,
	#category : #'OpenPonk-BPMN-Factory'
}

{ #category : #adding }
OPBPMNFactory class >> addFqnTransitions: aCollection in: aParticipant [
	aCollection do: [ :pair | self fqnTransitionFrom: pair key to: pair value in: aParticipant ]
]

{ #category : #moving }
OPBPMNFactory class >> detachParticipantsFrom: aDiagram [
	aDiagram elements removeAll
]

{ #category : #adding }
OPBPMNFactory class >> fqnTransitionFrom: fromName to: toName in: aParticipant [
	^ self transitionFrom: aParticipant @ fromName to: aParticipant @ toName
]

{ #category : #moving }
OPBPMNFactory class >> moveParticipantsFrom: aSourceDiagram to: aTargetDiagram [
	aTargetDiagram removeAll.
	"detach elements from old diagram without causing a cascade"
	aSourceDiagram elements do: [ :each | each announcer unsubscribe: aSourceDiagram ].
	aSourceDiagram elements do: [ :each | aTargetDiagram add: each ].
	aSourceDiagram elements removeAll
]

{ #category : #adding }
OPBPMNFactory class >> transitionFrom: fromNode to: toNode [
	| transition |
	transition := OPBPMNTransition from: fromNode to: toNode.
	fromNode addTransition: transition.
	toNode addTransition: transition.
	^ transition
]
