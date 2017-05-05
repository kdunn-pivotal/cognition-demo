package io.pivotal.madlib.pagerank;

import java.math.BigDecimal;
import java.util.List;

public class NodeLinksRank {

	private String key;
	private String[] links;
	private Double rank;

	public NodeLinksRank(String key, String[] strings, Double rank) {
		super();
		this.key = key;
		this.links = strings;
		this.rank = rank;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String[] getLinks() {
		return links;
	}

	public void setLinks(String[] links) {
		this.links = links;
	}

	public Double getRank() {
		return rank;
	}

	public void setRank(Double rank) {
		this.rank = rank;
	}

}
