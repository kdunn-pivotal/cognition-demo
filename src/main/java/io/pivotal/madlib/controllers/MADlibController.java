package io.pivotal.madlib.controllers;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.PUT;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.pivotal.madlib.pagerank.PageRankRepository;
import io.pivotal.madlib.pagerank.Edge;
import io.pivotal.madlib.pagerank.PageRankRecord;

@RestController
@ComponentScan({"io.pivotal.madlib.pagerank"})
class MADlibController {
    
	@Autowired private PageRankRepository repo;

    @RequestMapping(value = "/pagerank/top/{n}", method = GET)
    public List<PageRankRecord> getTopNRanked(@PathVariable("n") Integer topN) {
        return repo.getTopNRanked(topN);
    }
    @RequestMapping(value = "/pagerank/edges/{n}", method = GET)
    public List<Edge> getTopNRankedConnections(@PathVariable("n") Integer topN) {
    	return repo.getNEdges(topN);
    }
    

}
