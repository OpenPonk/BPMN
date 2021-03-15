Class {
	#name : #OPBPMNTransition,
	#superclass : #OPBPMNModel,
	#instVars : [
		'source',
		'target',
		'constraint'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #'instance creation' }
OPBPMNTransition class >> from: aSourceObject to: aTargetObject [
	^ self new
		from: aSourceObject to: aTargetObject;
		yourself
]

{ #category : #'instance creation' }
OPBPMNTransition class >> from: aSourceObject to: aTargetObject named: aString [
	^ self new
		from: aSourceObject to: aTargetObject;
		name: aString;
		yourself
]

{ #category : #accessing }
OPBPMNTransition >> allEntities [
	^ (Set with: self entity)
		,
			(self hasConstraint
				ifTrue: [ self constraint allEntities ]
				ifFalse: [ {} ])
]

{ #category : #accessing }
OPBPMNTransition >> constraint [
	^ constraint
]

{ #category : #accessing }
OPBPMNTransition >> constraint: aConstraint [
	self hasConstraint
		ifTrue: [ ^ self ].
	constraint := aConstraint.
	aConstraint addedTo: self.
	self announceAdded: aConstraint
]

{ #category : #accessing }
OPBPMNTransition >> constraints [
	^ constraint ifNil: [ #() ] ifNotNil: [ ^ {constraint} ]
]

{ #category : #'instance creation' }
OPBPMNTransition >> from: aSource to: aTarget [
	self source: aSource.
	self target: aTarget
]

{ #category : #accessing }
OPBPMNTransition >> has: anEntity [
	^ constraint = anEntity
]

{ #category : #accessing }
OPBPMNTransition >> hasConstraint [
	^ constraint isNotNil
]

{ #category : #accessing }
OPBPMNTransition >> removeConstraint [
	self hasConstraint
		ifFalse: [ ^ self ].
	constraint removedFrom: self.
	self announceRemoved: constraint.
	constraint := nil
]

{ #category : #accessing }
OPBPMNTransition >> source [
	^ source
]

{ #category : #accessing }
OPBPMNTransition >> source: aNode [
	source := aNode
]

{ #category : #accessing }
OPBPMNTransition >> target [
	^ target
]

{ #category : #accessing }
OPBPMNTransition >> target: aNode [
	target := aNode
]
