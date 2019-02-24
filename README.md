

# Allspark [![Chat with us on Slack](https://img.shields.io/badge/chat%20with%20us%20on-Slack-blue.svg)](https://lightpharosio.slack.com)

Allspark is a Docker based developer toolbox fully automated in term of configuration and parameterization between the different developpment tool stacks.

## About Allspark

Allspark has been initiated and created inside the actinium organization. As allspark has a new sponsor we have forked the original actinium\allspark to the new organisation sponsor lightpharos\allspark-neo .

actinium\allspark and lightpharosio\allspark-neo have the same objectives to provide a multi hosting DevOPS pipeline platform.
Neo provides an architecture evolution of the allspark product. Indeed actinium\allspark provides in one box a full stack contenerized. This solution is relevant for testing the platform automation and what the service can provide in one VM.
However we aim with neo to provide a better scalability by splitting the stack in different VM using for instace cloud automation script based on terraform.
Finally in a specific release of Neo we also aim to increase the level of agnosticity and scalability by using K8s docker orchestration system.

## actinium\allspark

allspark actiniumio is now deprecated. Everything moved officialy in lightpharosio .

## Current Repository organization

1. docs ==> Designs, User guides... documentation around the project
2. onebox ==> Ex actiniumio\allspark product (**Under stabilization**)
3. elasticsparks ==> Allspark IaaS product (**not initiated**)
4. Kubsparks ==> Allspark Kubernete product (**not initiated**)

## Launching Status

1. **In progress** --> Step 1: Reconfigure the Development pipeline used to develop allspark. (Realign with our new Cloud provider, Improve testing)
2. **In progress**--> Step 2: Configure lightpharosio/allspark-neo to provide a better project visibility in term of project releases, documentations.
3. Step 3: Target Features Roadmap
4. Step 4: Provide for specific users the ability to test the product in the different phases of the developpment.
5. Step 5: Relaunch the product development.


![Diagram]<div class="mxgraph" style="max-width:100%;" data-mxgraph="{&quot;highlight&quot;:&quot;#0000ff&quot;,&quot;lightbox&quot;:false,&quot;nav&quot;:true,&quot;edit&quot;:&quot;_blank&quot;,&quot;xml&quot;:&quot;&lt;mxfile modified=\&quot;2019-02-16T23:35:56.534Z\&quot; host=\&quot;www.draw.io\&quot; agent=\&quot;Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36\&quot; etag=\&quot;mR-By5i_tAOnO-MVLh3z\&quot; version=\&quot;10.2.3\&quot; type=\&quot;device\&quot;&gt;&lt;diagram id=\&quot;cKxy25QBsNlYdYQ1U5QF\&quot; name=\&quot;Scope\&quot;&gt;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&lt;/diagram&gt;&lt;/mxfile&gt;&quot;}"></div>
<script type="text/javascript" src="https://www.draw.io/js/viewer.min.js"></script>
