"
I am the base domain model class for all BPMN nodes. I manage graph connectivity by tracking incoming and outgoing flows, associations, and hierarchical containment within pools or lanes.
"
Class {
	#name : 'OPBPMNNodeModel',
	#superclass : 'OPModelObject',
	#instVars : [
		'associations'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'adding' }
OPBPMNNodeModel >> addAssociation: anAssociation [
	(associations includes: anAssociation)
		ifTrue: [ ^ self ].
	associations add: anAssociation.
	anAssociation source = self
		ifTrue: [ 
			anAssociation addedTo: self.
			self announceAdded: anAssociation ]
		ifFalse: [ self changed ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> allElements [

	^ super allElements
	  , (self associations flatCollect: [ :each | each withAllElements ])
]

{ #category : 'accessing' }
OPBPMNNodeModel >> associations [

	^ associations
]

{ #category : 'accessing' }
OPBPMNNodeModel >> edges [

	^ associations
]

{ #category : 'hooks' }
OPBPMNNodeModel >> enclosingPool [

	^ self owner ifNotNil: [ self owner enclosingPool ]
]

{ #category : 'testing' }
OPBPMNNodeModel >> has: anElement [

	^ (super has: anElement) or: [ associations includes: anElement ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> incoming [

	^ associations select: [ :each | each target = self ]
]

{ #category : 'initialization' }
OPBPMNNodeModel >> initialize [

	super initialize.
	associations := OrderedCollection new
]

{ #category : 'testing' }
OPBPMNNodeModel >> isEdge [
	^ false
]

{ #category : 'testing' }
OPBPMNNodeModel >> isNode [
	^ true
]

{ #category : 'accessing' }
OPBPMNNodeModel >> nodes [
	^ elements 
]

{ #category : 'accessing' }
OPBPMNNodeModel >> outgoing [

	^ associations select: [ :each | each source = self ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : 'removing' }
OPBPMNNodeModel >> remove: anElement [
	(associations includes: anElement) ifTrue: [
		anElement removeFrom: self.
		associations remove: anElement ifAbsent: [ ].
		self announceRemovedChild: anElement.
		^ anElement ].
	^ super remove: anElement
]

{ #category : 'removing' }
OPBPMNNodeModel >> removeAssociation: anAssociation [
	associations remove: anAssociation ifAbsent: [ ^ self ].
	self announceRemovedChild: anAssociation
]
