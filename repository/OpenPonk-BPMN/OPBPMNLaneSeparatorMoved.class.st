"
Carries the vertical delta when a user interactively drags a lane separator on the canvas to resize adjacent lanes.
"
Class {
	#name : 'OPBPMNLaneSeparatorMoved',
	#superclass : 'Announcement',
	#instVars : [
		'delta'
	],
	#category : 'OpenPonk-BPMN-Announcements',
	#package : 'OpenPonk-BPMN',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPBPMNLaneSeparatorMoved class >> delta: aNumber [
	^ self new
		delta: aNumber;
		yourself
]

{ #category : 'accessing' }
OPBPMNLaneSeparatorMoved >> delta [
	^ delta
]

{ #category : 'accessing' }
OPBPMNLaneSeparatorMoved >> delta: aNumber [
	delta := aNumber
]
