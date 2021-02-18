Class {
	#name : #OPBPMNIcon,
	#superclass : #Object,
	#instVars : [
		'icons'
	],
	#classVars : [
		'Current'
	],
	#category : #'OpenPonk-BPMN-Icons'
}

{ #category : #initialization }
OPBPMNIcon >> activity [
	^ Form
		fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self activityContent readStream)
]

{ #category : #initialization }
OPBPMNIcon >> activityContent [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABEAAAARCAYAAAA7bUf6AAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAARRJREFUOBGtkz9OAkEUh3cBE62JiQnxEhrDBcDCq3ABQ0FhbecZvACtnIFTGBIJBcbCRoHvG3gEElQG+SXfzs68P/tm9k1RLFVdjblDiiuJqsAMzuEKXNtHQ5zGUEZAh0kPRvCtAX7SHIMfvoQHeIKiDR9w4yRD1/i+w617eoQ+PEMN3NpfOsHhFc7gzrJ8eYND5JmcmsQ9WkGOjFHp75jEQ4xFDTlKcSb5t46WxJJ+64tdlYZ/Gj1QX75WnlvGXdGsbZ6fcaVJPuECVPTIpuPSsv0Mu3HGFy2w85pOMmSHT6FtJQO4B7s27k70D0tJbjO+7mh/NKALLxoNcBt18D5EQJwPS2uZIOze4gms/7AVHaIUtwBfLy8Zr5ir1gAAAABJRU5ErkJggg=='
]

{ #category : #initialization }
OPBPMNIcon >> initialize [
	super initialize.
	self initializeIcons
]

{ #category : #initialization }
OPBPMNIcon >> initializeIcons [
	icons := LRUCache new
		maximumWeight: 64;
		factory: [ :key | self perform: key ];
		yourself
]
