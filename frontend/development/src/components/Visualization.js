import React, { useEffect, useMemo, useState } from "react";
import Graph from "graphology";
import { SigmaContainer, useLoadGraph, useRegisterEvents } from "@react-sigma/core";
import forceAtlas2 from "graphology-layout-forceatlas2";
import {random} from "graphology-layout";
import Calendar from "react-calendar";
import { InteractiveBrowserCredential } from "@azure/identity";
import { BlobServiceClient } from "@azure/storage-blob";
import "@react-sigma/core/lib/style.css";
import "react-calendar/dist/Calendar.css";

export const LoadGraph = (props) => {
  const loadGraph = useLoadGraph();
  const registerEvents = useRegisterEvents();

  // The InteractiveBrowserCredential authentication requires one Entra ID App Registration.
  // https://github.com/Azure/azure-sdk-for-js/blob/@azure/identity_4.6.0/sdk/identity/identity/interactive-browser-credential.md#for-browsers
  var options = {
    clientId: "<app_registration_client_id>"
  };
  const blobStorageClient = new BlobServiceClient(
    "https://<storage_account_name>.blob.core.windows.net/",
    new InteractiveBrowserCredential(options)
  );
  // Alternative approach to the Entra ID App Registration: Storage Account SAS Token.
  // Generate one Storage Account SAS Token and configure the blobStorageClient:
  // const blobStorageClient = new BlobServiceClient(
  //   "<Storage_Account_SAS_Token>"
  // );

  // Storage Account container name
  const containerName = "data";

  async function blobToString(blobBody) {
    const fileReader = new FileReader();
    return new Promise((resolve, reject) => {
      fileReader.onloadend = (ev) => {
        resolve(ev.target.result);
      };
      fileReader.onerror = reject;
      fileReader.readAsText(blobBody);
    });
  }

  useEffect(() => {
    console.log("Visualize graph on date: " + props.date);
    if(props.date === undefined) {
      return;
    }
    var dateValue = (props.date.getDate()>9 ? '' : '0') + props.date.getDate() + "_" + (props.date.getMonth()>9 ? '' : '0') + (props.date.getMonth() + 1) + "_" + props.date.getFullYear();
    console.log("Date value: " + dateValue);
    
    var groupsJsonFileName = "groups_" + dateValue + ".json";
    var usersJsonFileName = "users_" + dateValue + ".json";
    var groupsMembersJsonFileName = "groups_members_" + dateValue + ".json";

    const containerClient = blobStorageClient.getContainerClient(containerName);

    const fetchData = async () => {
      const groupsBlobClient = containerClient.getBlobClient(groupsJsonFileName);
      // https://learn.microsoft.com/en-us/javascript/api/%40azure/storage-blob/blobclient?view=azure-node-latest#@azure-storage-blob-blobclient-download
      const groupsDownloadBlockBlobResponse = await groupsBlobClient.download();
      const groupsJson = (
        await blobToString(await groupsDownloadBlockBlobResponse.blobBody)
      );
      // console.log("Downloaded groups blob content:", groupsJson);

      const usersBlobClient = containerClient.getBlobClient(usersJsonFileName);
      const usersDownloadBlockBlobResponse = await usersBlobClient.download();
      const usersJson = (
        await blobToString(await usersDownloadBlockBlobResponse.blobBody)
      );
      // console.log("Downloaded users blob content:", usersJson);

      const groupsMembersBlobClient = containerClient.getBlobClient(groupsMembersJsonFileName);
      const groupsMembersDownloadBlockBlobResponse = await groupsMembersBlobClient.download();
      const groupsMembersJson = (
        await blobToString(await groupsMembersDownloadBlockBlobResponse.blobBody)
      );
      // console.log("Downloaded groups members blob content:", groupsMembersJson);
      return {groupsJson, usersJson, groupsMembersJson};
    }

    fetchData()
    .then((data) => {
      var groups = JSON.parse(data.groupsJson);
      console.log(groups);
      var users = JSON.parse(data.usersJson);
      console.log(users);
      var groupsMembers = JSON.parse(data.groupsMembersJson);
      console.log(groupsMembers);
  
      const graph = new Graph();
  
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
    })
    .catch(console.error);
  }, [loadGraph, registerEvents, props.refresh]);
  
  return null;
};

function Visualization() {
  const [windowDimensions, setWindowDimensions] = useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  const sigmaStyle = { height: windowDimensions.height, width: windowDimensions.width - 250 };

  const [dates, setDates] = useState([]);
  const [date, setDate] = useState(new Date());

  const [refresh, doRefresh] = useState(0);
  const [errorMessage, setErrorMessage] = useState('');

  const settings = useMemo(
    () => ({
      allowInvalidContainer: true
    }),
    [],
  );

  // The InteractiveBrowserCredential authentication requires one Entra ID App Registration.
  // https://github.com/Azure/azure-sdk-for-js/blob/@azure/identity_4.6.0/sdk/identity/identity/interactive-browser-credential.md#for-browsers
  var options = {
    clientId: "<app_registration_client_id>"
  };
  const blobStorageClient = new BlobServiceClient(
    "https://<storage_account_name>.blob.core.windows.net/",
    new InteractiveBrowserCredential(options)
  );
  // Alternative approach to the Entra ID App Registration: Storage Account SAS Token.
  // Generate one Storage Account SAS Token and configure the blobStorageClient:
  // const blobStorageClient = new BlobServiceClient(
  //   "<Storage_Account_SAS_Token>"
  // );

  // Storage Account container name
  const containerName = "data";
  
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
    const fetchData = async () => {
      var fileNames = []
      const containerClient = blobStorageClient.getContainerClient(containerName);
      let blobs = containerClient.listBlobsFlat();
      for await (const blob of blobs) {
        fileNames.push(blob.name);
      };
      return fileNames;
    }

    fetchData()
    .then((fileNames) => {
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
    })
    .catch(console.error);
  }, []);

  return (
    <div style={{width:'100%', height:'100%', display:'flex', flexDirection:'row'}}>
      <SigmaContainer style={sigmaStyle} graph={Graph} settings={settings}>
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

export default Visualization;
