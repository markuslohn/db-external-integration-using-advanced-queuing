package com.esentri.integration.aq;

import lombok.Data;

@Data
public class EventData {
	private String specversion;
	private String id;
	private String type;
	private String source;
	private String data;
}
