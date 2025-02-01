import React, { useEffect, useState } from "react";
import Graph from "graphology";
import { SigmaContainer, useLoadGraph, useRegisterEvents } from "@react-sigma/core";
import forceAtlas2 from "graphology-layout-forceatlas2";
import {random} from "graphology-layout";
import Calendar from "react-calendar";
import "@react-sigma/core/lib/style.css";
import "react-calendar/dist/Calendar.css";

// Local test for React-Sigma

export const LoadGraph = (props) => {
  const loadGraph = useLoadGraph();
  const registerEvents = useRegisterEvents();

  const groupsJson = `[
  {
    "DisplayName": "Tech Titans",
    "Id": "811525a4-3b99-46fb-b2a7-ebb79dc30d5a"
  },
  {
    "DisplayName": "Code Crew",
    "Id": "59fd9bfe-1301-4c95-959d-3a2645668503"
  },
  {
    "DisplayName": "Digital Dream Team",
    "Id": "7a35a729-d346-46e2-8df4-92e8b90fad67"
  },
  {
    "DisplayName": "Innovation Initiators",
    "Id": "21eefa67-72aa-4284-b95b-2e851b94d622"
  },
  {
    "DisplayName": "The Tech Collective",
    "Id": "97dc3104-070c-4722-87e3-824db29053e5"
  },
  {
    "DisplayName": "Agile Alliance",
    "Id": "16aa94c1-ea8d-4045-9d4d-26e406f9971b"
  },
  {
    "DisplayName": "Smart Solutions Squad",
    "Id": "b9f54136-0ff5-469b-a709-5e8408f54b48"
  },
  {
    "DisplayName": "Creative Coders",
    "Id": "edfb341d-6efd-45b1-bf37-15b5638edbbc"
  }
]`
  const usersJson = `[
  {
    "DisplayName": "Yolanda Maas",
    "Id": "24310a6c-1a7f-4470-9c47-7dc236633da0"
  },
  {
    "DisplayName": "Gertrude Teke",
    "Id": "2c30b117-087c-4d7e-8318-f0de3ff38f83"
  },
  {
    "DisplayName": "Leelavathi Bosko",
    "Id": "d89c6b66-7779-4521-bb1a-1b2e94a21783"
  },
  {
    "DisplayName": "Blagovesta Bösch",
    "Id": "121af84d-a3a4-40e2-b5b7-8929f9363ad1"
  },
  {
    "DisplayName": "Stefani Dreyer",
    "Id": "471d7a1f-5dc9-4325-9e50-692d25b2a9ab"
  },
  {
    "DisplayName": "Livie Kokot",
    "Id": "903ce149-db7e-44da-9d08-4a7a37350865"
  },
  {
    "DisplayName": "Ghada Tipton",
    "Id": "df7f4596-67f6-445f-96a8-18246e10cd5f"
  },
  {
    "DisplayName": "Berenice Angus",
    "Id": "d05bf035-5534-4935-8e6c-4f21664451a8"
  },
  {
    "DisplayName": "Chifuniro Meadhra",
    "Id": "5e436ef2-15e0-4976-96b3-500e6cfca06b"
  },
  {
    "DisplayName": "Torill Sandström",
    "Id": "2cac79dc-e737-4e62-8213-ef54015f46b4"
  },
  {
    "DisplayName": "Nomiki Foster",
    "Id": "0c3fdef8-769c-43ed-b780-508b02fba976"
  },
  {
    "DisplayName": "Sága Klementová",
    "Id": "f2423f1d-5c81-4f9f-a4fa-48489fe9e2fb"
  },
  {
    "DisplayName": "Flavia Henson",
    "Id": "dda59ae9-43bb-4fd5-99b2-dfe3e172af8c"
  },
  {
    "DisplayName": "Davina MacCrumb",
    "Id": "92e13720-c474-44af-823b-377df411be2f"
  },
  {
    "DisplayName": "Liselotte Aleksandrova",
    "Id": "f13fe9b7-798a-43ab-957d-7927b8692ed3"
  },
  {
    "DisplayName": "Terezie Sadowska",
    "Id": "150ccf29-a8c5-4bd6-a5a8-dc16f42eb25f"
  },
  {
    "DisplayName": "Allochka Rains",
    "Id": "ab07602d-f0e7-4369-8f2a-aa5c952c1c69"
  },
  {
    "DisplayName": "Heaven Geiszler",
    "Id": "3e42fdc8-47dc-4bdd-ba41-99a9cd93169a"
  },
  {
    "DisplayName": "Selma Danniell",
    "Id": "152d4dd3-250c-40eb-9af6-c0d9c8568e1f"
  },
  {
    "DisplayName": "Zoë Tifft",
    "Id": "2b69e898-ca47-438a-9bf1-477aacedf4f7"
  },
  {
    "DisplayName": "Branca Priestley",
    "Id": "075558c3-ea93-4464-9c23-dbf180be9cbd"
  },
  {
    "DisplayName": "Ivana Ash",
    "Id": "812b9505-03a5-4cd5-8b3c-d73615420cc7"
  },
  {
    "DisplayName": "Hadas Poindexter",
    "Id": "c8424ad5-f14f-4b5e-8000-8866ee3e47be"
  },
  {
    "DisplayName": "Ndidi Oquendo",
    "Id": "1e6444bd-fcec-4dce-9835-b084a0088fc5"
  },
  {
    "DisplayName": "Rosinha Kaluža",
    "Id": "38e991b6-40f6-4083-a251-6cb4c359821d"
  },
  {
    "DisplayName": "Esmanur Elena",
    "Id": "fdf7aeea-aa79-422b-b9c3-4baae344b018"
  },
  {
    "DisplayName": "Felicia Morandi",
    "Id": "af60e9eb-db75-46ce-97e1-73b132fc8d84"
  },
  {
    "DisplayName": "Xanthia Néill",
    "Id": "989e8471-78b3-445d-8641-5f5d18d2fac7"
  },
  {
    "DisplayName": "Sacnite Nilsen",
    "Id": "630ac2d2-345a-4539-8f7a-4bc3e10f6702"
  }
]`
  const groupsMembersJson = `[
  {
    "MemberIds": [
      "24310a6c-1a7f-4470-9c47-7dc236633da0",
      "2c30b117-087c-4d7e-8318-f0de3ff38f83",
      "92e13720-c474-44af-823b-377df411be2f",
      "af60e9eb-db75-46ce-97e1-73b132fc8d84"
    ],
    "GroupId": "811525a4-3b99-46fb-b2a7-ebb79dc30d5a"
  },
  {
    "MemberIds": [
      "630ac2d2-345a-4539-8f7a-4bc3e10f6702",
      "989e8471-78b3-445d-8641-5f5d18d2fac7",
      "af60e9eb-db75-46ce-97e1-73b132fc8d84",
      "fdf7aeea-aa79-422b-b9c3-4baae344b018",
      "38e991b6-40f6-4083-a251-6cb4c359821d",
      "1e6444bd-fcec-4dce-9835-b084a0088fc5",
      "c8424ad5-f14f-4b5e-8000-8866ee3e47be",
      "f13fe9b7-798a-43ab-957d-7927b8692ed3"
    ],
    "GroupId": "59fd9bfe-1301-4c95-959d-3a2645668503"
  },
  {
    "MemberIds": [
      "471d7a1f-5dc9-4325-9e50-692d25b2a9ab",
      "903ce149-db7e-44da-9d08-4a7a37350865",
      "df7f4596-67f6-445f-96a8-18246e10cd5f",
      "f2423f1d-5c81-4f9f-a4fa-48489fe9e2fb"
    ],
    "GroupId": "7a35a729-d346-46e2-8df4-92e8b90fad67"
  },
  {
    "MemberIds": [
      "d05bf035-5534-4935-8e6c-4f21664451a8",
      "5e436ef2-15e0-4976-96b3-500e6cfca06b",
      "121af84d-a3a4-40e2-b5b7-8929f9363ad1"
    ],
    "GroupId": "21eefa67-72aa-4284-b95b-2e851b94d622"
  },
  {
    "MemberIds": [
      "d05bf035-5534-4935-8e6c-4f21664451a8",
      "2cac79dc-e737-4e62-8213-ef54015f46b4",
      "0c3fdef8-769c-43ed-b780-508b02fba976",
      "075558c3-ea93-4464-9c23-dbf180be9cbd",
      "38e991b6-40f6-4083-a251-6cb4c359821d",
      "989e8471-78b3-445d-8641-5f5d18d2fac7",
      "f13fe9b7-798a-43ab-957d-7927b8692ed3"
    ],
    "GroupId": "97dc3104-070c-4722-87e3-824db29053e5"
  },
  {
    "MemberIds": [
      "152d4dd3-250c-40eb-9af6-c0d9c8568e1f",
      "2b69e898-ca47-438a-9bf1-477aacedf4f7",
      "075558c3-ea93-4464-9c23-dbf180be9cbd",
      "d89c6b66-7779-4521-bb1a-1b2e94a21783"
    ],
    "GroupId": "16aa94c1-ea8d-4045-9d4d-26e406f9971b"
  },
  {
    "MemberIds": [
      "d05bf035-5534-4935-8e6c-4f21664451a8",
      "24310a6c-1a7f-4470-9c47-7dc236633da0",
      "152d4dd3-250c-40eb-9af6-c0d9c8568e1f",
      "812b9505-03a5-4cd5-8b3c-d73615420cc7",
      "c8424ad5-f14f-4b5e-8000-8866ee3e47be"
    ],
    "GroupId": "b9f54136-0ff5-469b-a709-5e8408f54b48"
  },
  {
    "MemberIds": [
      "ab07602d-f0e7-4369-8f2a-aa5c952c1c69",
      "d05bf035-5534-4935-8e6c-4f21664451a8",
      "989e8471-78b3-445d-8641-5f5d18d2fac7",
      "3e42fdc8-47dc-4bdd-ba41-99a9cd93169a",
      "1e6444bd-fcec-4dce-9835-b084a0088fc5",
      "075558c3-ea93-4464-9c23-dbf180be9cbd",
      "150ccf29-a8c5-4bd6-a5a8-dc16f42eb25f",
      "dda59ae9-43bb-4fd5-99b2-dfe3e172af8c",
      "f2423f1d-5c81-4f9f-a4fa-48489fe9e2fb"
    ],
    "GroupId": "edfb341d-6efd-45b1-bf37-15b5638edbbc"
  }
]`

  useEffect(() => {
    console.log("Visualize graph on date: " + props.date);
    var dateValue = (props.date.getDate()>9 ? '' : '0') + props.date.getDate() + "_" + (props.date.getMonth()>9 ? '' : '0') + (props.date.getMonth() + 1) + "_" + props.date.getFullYear();
    console.log("Date value: " + dateValue);

    const graph = new Graph();

    var groups = JSON.parse(groupsJson);
    var users = JSON.parse(usersJson);
    var groupsMembers = JSON.parse(groupsMembersJson);

    groups.forEach(group => {
      graph.addNode("group_" + group.Id, { x: Math.floor(Math.random()), y: Math.floor(Math.random()), label: group.DisplayName, size: 10, color: "#4b5563" });
    });

    users.forEach(user => {
      graph.addNode("user_" + user.Id, { x: Math.floor(Math.random()), y: Math.floor(Math.random()), label: user.DisplayName, size: 10, color: "#4b5563" });
    });

    var rel = 1;
    groupsMembers.forEach(groupsMember => {
      groupsMember.MemberIds.forEach(groupMember => {
        if(users.some(u => u.Id === groupMember)) {
          graph.addEdgeWithKey(rel, "group_" + groupsMember.GroupId, "user_" + groupMember, { label: rel, size: 0.5, color: "#4b5563" });
          rel = rel + 1;
        }
      });
    });

    registerEvents({
      clickNode: (event) => {
        console.log("Noede id: " + event.node);
        graph.forEachNode(
          function(id, attr) {
            if(id === event.node || graph.areDirectedNeighbors(id, event.node)) {
              if(id.startsWith("group_")) {
                attr.color = "#d93d1a";
              } else {
                attr.color = "#d9791a";
              }
            } else {
              attr.color = "#4b5563";
            }
          });
        graph.forEachEdge((edge, attr, source, target) => 
          {
            if(source === event.node || target === event.node) {
              attr.size = 1;
              attr.color = "#ffaa00";
            } else {
              attr.size = 0.5;
              attr.color = "#4b5563";
            }
          }
        );
        loadGraph(graph);
      }
    })

    random.assign(graph);
    forceAtlas2.assign(graph, {iterations: 50});
    loadGraph(graph);
  }, [loadGraph, registerEvents, props.refresh]);
  
  return null;
};

function VisualizationTest() {
  const [windowDimensions, setWindowDimensions] = useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  const sigmaStyle = { height: windowDimensions.height, width: windowDimensions.width - 250 };

  const [dates, setDates] = useState([]);
  const [date, setDate] = useState(new Date());

  const [refresh, doRefresh] = useState(0);
  const [errorMessage, setErrorMessage] = useState('');

  const fileNames = [
    "groups_01_02_2025.json",
    "users_01_02_2025.json",
    "groups_members_01_02_2025.json",
    "groups_18_01_2025.json",
    "users_18_01_2025.json",
    "groups_members_18_01_2025.json",
    "users_17_01_2025.json",
    "users_12_01_2025.json",
    "users_02_12_2024.json",
    "users_15_02_2024.json"
  ]
  
  function findStartWith(fileNames, arg) {
    return fileNames.filter(value => {
      return value.startsWith(arg);
    });
  }

  function isInArray(array, value) {
    return !!array.find(item => {return item.getTime() == value.getTime()});
  }

  function changeDate(newDate) {
    setDate(newDate);
    console.log('Change date: ' + newDate);
    var isDateAvailable = isInArray(dates, newDate);
    console.log("Is date available: " + isDateAvailable);
    if(isDateAvailable) {
      doRefresh(prev => prev + 1);
      setErrorMessage('');
    } else {
      setErrorMessage("The date " + newDate + " is not available.");
    }
  }

  useEffect(() => {
    setErrorMessage('');
    var usersFiles = findStartWith(fileNames, "users_");

    var usersDatesValues = usersFiles.map(value => {
      return value.substring(value.indexOf("_") + 1, value.length - 5);
    });

    var usersDates = usersDatesValues.map(value => {
      const parts = value.split("_");

      const year = parseInt(parts[2], 10);
      const month = parseInt(parts[1], 10) - 1;
      const day = parseInt(parts[0], 10);

      return new Date(year, month, day);
    });
    
    usersDates.sort((a,b) => b.getTime() - a.getTime());
    setDates(usersDates);
    setDate(usersDates[0])
    console.log(usersDates);
  }, []);

  return (
    <div style={{display:'flex', flexDirection:'row'}}>
      <SigmaContainer style={sigmaStyle}>
        <LoadGraph refresh={refresh} date={date} />
      </SigmaContainer>
      <div style={{width:'250px', height:'100%'}}>
        <Calendar onChange={changeDate} value={date} />
        <div>
          <span>{errorMessage}</span>
        </div>
      </div>
    </div>
  );
}

export default VisualizationTest;
