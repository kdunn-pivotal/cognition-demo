package io.pivotal.madlib.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import io.pivotal.madlib.pagerank.PageRankRepository;

@Controller
@ComponentScan({"io.pivotal.madlib.pagerank"})
public class UIController {
	
	@Autowired PageRankRepository repo;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("nodeData", repo.getTopNRanked(0) );
        model.addAttribute("edgeData", repo.getNEdges(0) );

        /* static/templates/index.ftl */
        return "index";
    }
}
